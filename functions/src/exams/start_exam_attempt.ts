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

interface ValidatedQuestion {
    questionId: string;
    data: DocumentData;
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

      const questions = questionsSnapshot.docs
        .map((questionDocument) => {
          return validateQuestion(
            questionDocument.id,
            questionDocument.data(),
            examId,
          );
        })
        .sort((first, second) => {
          return getQuestionOrder(first.data) -
                        getQuestionOrder(second.data);
        });

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
            question.data,
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
): ValidatedQuestion {
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

  readNonNegativeInteger(
    data,
    "questionOrder",
  );

  const correctOption = readPositiveInteger(
    data,
    "correctOption",
  );

  if (correctOption > 4) {
    throw new HttpsError(
      "data-loss",
      "An exam question has an invalid correct option.",
    );
  }

  return {
    questionId,
    data,
  };
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
  let calculatedTotalScore = 0;

  for (const question of questions) {
    if (questionIds.has(question.questionId)) {
      throw new HttpsError(
        "data-loss",
        "The exam contains duplicate questions.",
      );
    }

    questionIds.add(question.questionId);

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

function getQuestionOrder(
  data: DocumentData,
): number {
  return readNonNegativeInteger(
    data,
    "questionOrder",
  );
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
