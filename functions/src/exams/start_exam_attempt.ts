import {
  DocumentData,
  FieldValue,
  Timestamp,
  getFirestore,
} from "firebase-admin/firestore";
import {
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";
import {
  createExamResultId,
  createSafeQuestionData,
  examAttemptStatuses,
  examCallableFunctionOptions,
  examCollections,
  examStatuses,
  getAuthenticatedStudent,
  getAuthenticatedStudentId,
  getRequestData,
  getRequiredString,
  handleExamFunctionError,
} from "./exam_functions_helper";

interface ValidatedExamData {
  examId: string;
  gradeId: string;
  examName: string;
  questionCount: number;
  durationMinutes: number;
  totalScore: number;
  examStatus: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

interface ValidatedQuestionCandidate {
  questionId: string;
  data: DocumentData;
  preferredOrder: number | null;
  createdAtMillis: number;
}

interface ValidatedQuestion {
  questionId: string;
  data: DocumentData;
  questionOrder: number;
}

export const startExamAttempt = onCall(
  examCallableFunctionOptions,
  async (request) => {
    try {
      const studentId = getAuthenticatedStudentId(
        request.auth,
      );

      const requestData = getRequestData(
        request.data,
      );

      const examId = getRequiredString(
        requestData,
        "examId",
      );

      const firestore = getFirestore();

      const student = await getAuthenticatedStudent(
        firestore,
        studentId,
      );

      const examReference = firestore
        .collection(examCollections.exams)
        .doc(examId);

      const examSnapshot = await examReference.get();

      if (!examSnapshot.exists) {
        throw new HttpsError(
          "not-found",
          "The requested exam does not exist.",
        );
      }

      const exam = validateExamData(
        examId,
        examSnapshot.data(),
      );

      validateExamAvailability(
        exam,
        student.gradeId,
      );

      const questionsSnapshot = await firestore
        .collection(examCollections.examQuestions)
        .where("examId", "==", examId)
        .get();

      const questionCandidates = questionsSnapshot.docs
        .map((questionDocument) => {
          return validateQuestion(
            questionDocument.id,
            questionDocument.data(),
            examId,
          );
        });

      const questions = normalizeQuestionOrders(
        questionCandidates,
      );

      validateExamQuestions(
        exam,
        questions,
      );

      const resultId = createExamResultId(
        examId,
        studentId,
      );

      const resultReference = firestore
        .collection(examCollections.examResults)
        .doc(resultId);

      const transactionResult = await firestore.runTransaction(
        async (transaction) => {
          const currentExamSnapshot = await transaction.get(
            examReference,
          );

          const existingResultSnapshot = await transaction.get(
            resultReference,
          );

          if (!currentExamSnapshot.exists) {
            throw new HttpsError(
              "not-found",
              "The requested exam does not exist.",
            );
          }

          const currentExam = validateExamData(
            examId,
            currentExamSnapshot.data(),
          );

          validateExamAvailability(
            currentExam,
            student.gradeId,
          );

          if (existingResultSnapshot.exists) {
            throw new HttpsError(
              "already-exists",
              "An attempt already exists for this exam.",
            );
          }

          const startedAt = Timestamp.now();

          const expiresAt = Timestamp.fromMillis(
            startedAt.toMillis() +
            currentExam.durationMinutes * 60 * 1000,
          );

          const attemptData = {
            resultId,
            examId,
            studentId,
            studentName: student.studentName,
            gradeId: student.gradeId,
            gradeName: student.gradeName,
            status: examAttemptStatuses.inProgress,
            score: null,
            totalScore: currentExam.totalScore,
            startedAt,
            expiresAt,
            submittedAt: null,
            createdAt: startedAt,
            updatedAt: startedAt,
          };

          transaction.create(
            resultReference,
            attemptData,
          );

          const currentExamData =
            currentExamSnapshot.data();

          const firstAttemptAt =
            currentExamData?.firstAttemptAt;

          const examUpdates: Record<string, unknown> = {
            participantsCount: FieldValue.increment(1),
            updatedAt: startedAt,
          };

          if (!(firstAttemptAt instanceof Timestamp)) {
            examUpdates.firstAttemptAt = startedAt;
          }

          transaction.update(
            examReference,
            examUpdates,
          );

          return {
            exam: currentExam,
            attempt: attemptData,
          };
        },
      );

      return {
        exam: createSafeExamResponse(
          transactionResult.exam,
        ),
        attempt: transactionResult.attempt,
        questions: questions.map((question) => {
          return createSafeQuestionData(
            question.questionId,
            {
              ...question.data,
              questionOrder: question.questionOrder,
            },
          );
        }),
      };
    } catch (error) {
      handleExamFunctionError(
        error,
        "startExamAttempt",
      );
    }
  },
);

function validateExamData(
  examId: string,
  data: DocumentData | undefined,
): ValidatedExamData {
  if (data === undefined) {
    throw new HttpsError(
      "data-loss",
      "The exam data is unavailable.",
    );
  }

  const gradeId = readRequiredString(
    data,
    "gradeId",
  );

  const examName = readRequiredString(
    data,
    "examName",
  );

  const questionCount = readPositiveInteger(
    data,
    "questionCount",
  );

  const durationMinutes = readPositiveInteger(
    data,
    "durationMinutes",
  );

  const totalScore = readPositiveInteger(
    data,
    "totalScore",
  );

  const examStatus = readRequiredString(
    data,
    "examStatus",
  );

  const createdAt = readRequiredTimestamp(
    data,
    "createdAt",
  );

  const updatedAt = data.updatedAt instanceof Timestamp ?
    data.updatedAt :
    createdAt;

  if (data.isDeleting !== false) {
    throw new HttpsError(
      "failed-precondition",
      "The exam is currently unavailable.",
    );
  }

  return {
    examId,
    gradeId,
    examName,
    questionCount,
    durationMinutes,
    totalScore,
    examStatus,
    createdAt,
    updatedAt,
  };
}

function validateExamAvailability(
  exam: ValidatedExamData,
  studentGradeId: string,
): void {
  if (exam.examStatus !== examStatuses.published) {
    throw new HttpsError(
      "failed-precondition",
      "The exam is not available.",
    );
  }

  if (exam.gradeId !== studentGradeId) {
    throw new HttpsError(
      "permission-denied",
      "This exam is not assigned to the student grade.",
    );
  }
}

function validateQuestion(
  questionId: string,
  data: DocumentData,
  examId: string,
): ValidatedQuestionCandidate {
  const questionExamId = readRequiredString(
    data,
    "examId",
  );

  if (questionExamId !== examId) {
    throw new HttpsError(
      "data-loss",
      "An exam question belongs to another exam.",
    );
  }

  readRequiredString(
    data,
    "questionText",
  );

  readRequiredString(
    data,
    "option1",
  );

  readRequiredString(
    data,
    "option2",
  );

  readRequiredString(
    data,
    "option3",
  );

  readRequiredString(
    data,
    "option4",
  );

  readPositiveInteger(
    data,
    "questionScore",
  );

  const preferredOrder = readPreferredQuestionOrder(
    questionId,
    data,
  );

  const correctOption = readNonNegativeInteger(
    data,
    "correctOption",
  );

  if (correctOption > 3) {
    throw new HttpsError(
      "data-loss",
      "An exam question has an invalid correct option.",
    );
  }

  return {
    questionId,
    data,
    preferredOrder,
    createdAtMillis: readQuestionCreatedAtMillis(data),
  };
}

function normalizeQuestionOrders(
  questions: ValidatedQuestionCandidate[],
): ValidatedQuestion[] {
  const sortedQuestions = [...questions].sort(
    compareQuestionCandidates,
  );

  return sortedQuestions.map((question, index) => {
    return {
      questionId: question.questionId,
      data: question.data,
      questionOrder: index,
    };
  });
}

function compareQuestionCandidates(
  first: ValidatedQuestionCandidate,
  second: ValidatedQuestionCandidate,
): number {
  const firstOrder = first.preferredOrder;
  const secondOrder = second.preferredOrder;

  if (firstOrder !== null && secondOrder !== null) {
    const orderComparison = firstOrder - secondOrder;

    if (orderComparison !== 0) {
      return orderComparison;
    }
  } else if (firstOrder !== null) {
    return -1;
  } else if (secondOrder !== null) {
    return 1;
  }

  const dateComparison =
    first.createdAtMillis - second.createdAtMillis;

  if (dateComparison !== 0) {
    return dateComparison;
  }

  return first.questionId.localeCompare(second.questionId);
}

function validateExamQuestions(
  exam: ValidatedExamData,
  questions: ValidatedQuestion[],
): void {
  if (questions.length !== exam.questionCount) {
    throw new HttpsError(
      "failed-precondition",
      "The exam questions are incomplete.",
    );
  }

  const questionIds = new Set<string>();
  const questionOrders = new Set<number>();
  let calculatedTotalScore = 0;

  for (const question of questions) {
    if (questionIds.has(question.questionId)) {
      throw new HttpsError(
        "data-loss",
        "The exam contains duplicate questions.",
      );
    }

    questionIds.add(question.questionId);

    if (questionOrders.has(question.questionOrder)) {
      throw new HttpsError(
        "data-loss",
        "The exam contains duplicate question orders.",
      );
    }

    questionOrders.add(question.questionOrder);

    calculatedTotalScore += readPositiveInteger(
      question.data,
      "questionScore",
    );
  }

  if (calculatedTotalScore !== exam.totalScore) {
    throw new HttpsError(
      "failed-precondition",
      "The exam total score does not match its questions.",
    );
  }
}

function createSafeExamResponse(
  exam: ValidatedExamData,
): Record<string, unknown> {
  return {
    examId: exam.examId,
    gradeId: exam.gradeId,
    examName: exam.examName,
    questionCount: exam.questionCount,
    durationMinutes: exam.durationMinutes,
    totalScore: exam.totalScore,
    examStatus: exam.examStatus,
    createdAt: exam.createdAt,
    updatedAt: exam.updatedAt,
  };
}

function readPreferredQuestionOrder(
  questionId: string,
  data: DocumentData,
): number | null {
  const storedQuestionOrder = data.questionOrder;

  if (
    typeof storedQuestionOrder === "number" &&
    Number.isSafeInteger(storedQuestionOrder) &&
    storedQuestionOrder >= 0
  ) {
    return storedQuestionOrder;
  }

  const questionIdMatch = /_(\d+)$/.exec(questionId);

  if (questionIdMatch === null) {
    return null;
  }

  const parsedQuestionOrder = Number.parseInt(
    questionIdMatch[1],
    10,
  );

  if (!Number.isSafeInteger(parsedQuestionOrder)) {
    return null;
  }

  return parsedQuestionOrder;
}

function readQuestionCreatedAtMillis(
  data: DocumentData,
): number {
  if (data.createdAt instanceof Timestamp) {
    return data.createdAt.toMillis();
  }

  if (data.updatedAt instanceof Timestamp) {
    return data.updatedAt.toMillis();
  }

  return Number.MAX_SAFE_INTEGER;
}

function readRequiredString(
  data: DocumentData,
  key: string,
): string {
  const value = data[key];

  if (
    typeof value !== "string" ||
    value.trim().length === 0
  ) {
    throw new HttpsError(
      "data-loss",
      `The ${key} field is invalid.`,
    );
  }

  return value.trim();
}

function readPositiveInteger(
  data: DocumentData,
  key: string,
): number {
  const value = data[key];

  if (
    typeof value !== "number" ||
    !Number.isInteger(value) ||
    value <= 0
  ) {
    throw new HttpsError(
      "data-loss",
      `The ${key} field is invalid.`,
    );
  }

  return value;
}

function readNonNegativeInteger(
  data: DocumentData,
  key: string,
): number {
  const value = data[key];

  if (
    typeof value !== "number" ||
    !Number.isInteger(value) ||
    value < 0
  ) {
    throw new HttpsError(
      "data-loss",
      `The ${key} field is invalid.`,
    );
  }

  return value;
}

function readRequiredTimestamp(
  data: DocumentData,
  key: string,
): Timestamp {
  const value = data[key];

  if (!(value instanceof Timestamp)) {
    throw new HttpsError(
      "data-loss",
      `The ${key} field is invalid.`,
    );
  }

  return value;
}
