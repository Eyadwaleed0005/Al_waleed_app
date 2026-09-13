import {
  DocumentData,
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

interface ValidatedAttemptData {
    resultId: string;
    examId: string;
    studentId: string;
    status: string;
    totalScore: number;
    startedAt: Timestamp;
    expiresAt: Timestamp;
    score: number | null;
    submittedAt: Timestamp | null;
}

interface ValidatedQuestion {
    questionId: string;
    data: DocumentData;
    questionOrder: number;
}

export const getStudentExam = onCall(
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

      const resultId = getRequiredString(
        requestData,
        "resultId",
      );

      const expectedResultId = createExamResultId(
        examId,
        studentId,
      );

      if (resultId !== expectedResultId) {
        throw new HttpsError(
          "permission-denied",
          "The exam attempt identifier is invalid.",
        );
      }

      const firestore = getFirestore();

      const student = await getAuthenticatedStudent(
        firestore,
        studentId,
      );

      const resultReference = firestore
        .collection(examCollections.examResults)
        .doc(resultId);

      const examReference = firestore
        .collection(examCollections.exams)
        .doc(examId);

      const [
        resultSnapshot,
        examSnapshot,
        questionsSnapshot,
      ] = await Promise.all([
        resultReference.get(),
        examReference.get(),
        firestore
          .collection(examCollections.examQuestions)
          .where("examId", "==", examId)
          .get(),
      ]);

      if (!resultSnapshot.exists) {
        throw new HttpsError(
          "not-found",
          "The exam attempt does not exist.",
        );
      }

      if (!examSnapshot.exists) {
        throw new HttpsError(
          "not-found",
          "The requested exam does not exist.",
        );
      }

      const attempt = validateAttemptData(
        resultId,
        resultSnapshot.data(),
      );

      validateAttemptOwnership(
        attempt,
        examId,
        studentId,
      );

      if (attempt.status !== examAttemptStatuses.inProgress) {
        throw new HttpsError(
          "failed-precondition",
          "Only an exam attempt in progress can be resumed.",
        );
      }

      const exam = validateExamData(
        examId,
        examSnapshot.data(),
      );

      if (exam.gradeId !== student.gradeId) {
        throw new HttpsError(
          "permission-denied",
          "This exam is not assigned to the student grade.",
        );
      }

      if (attempt.totalScore !== exam.totalScore) {
        throw new HttpsError(
          "data-loss",
          "The exam attempt score data is inconsistent.",
        );
      }

      const questions = questionsSnapshot.docs
        .map((questionDocument) => {
          return validateQuestion(
            questionDocument.id,
            questionDocument.data(),
            examId,
          );
        })
        .sort((first, second) => {
          return first.questionOrder -
                        second.questionOrder;
        });

      validateExamQuestions(
        exam,
        questions,
      );

      return {
        exam: createSafeExamResponse(exam),
        attempt: createSafeAttemptResponse(attempt),
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
        "getStudentExam",
      );
    }
  },
);

function validateAttemptData(
  resultId: string,
  data: DocumentData | undefined,
): ValidatedAttemptData {
  if (data === undefined) {
    throw new HttpsError(
      "data-loss",
      "The exam attempt data is unavailable.",
    );
  }

  const storedResultId = readRequiredString(
    data,
    "resultId",
  );

  if (storedResultId !== resultId) {
    throw new HttpsError(
      "data-loss",
      "The exam attempt identifier is inconsistent.",
    );
  }

  const examId = readRequiredString(
    data,
    "examId",
  );

  const studentId = readRequiredString(
    data,
    "studentId",
  );

  const status = readRequiredString(
    data,
    "status",
  );

  const totalScore = readPositiveInteger(
    data,
    "totalScore",
  );

  const startedAt = readRequiredTimestamp(
    data,
    "startedAt",
  );

  const expiresAt = readRequiredTimestamp(
    data,
    "expiresAt",
  );

  if (expiresAt.toMillis() <= startedAt.toMillis()) {
    throw new HttpsError(
      "data-loss",
      "The exam attempt time data is invalid.",
    );
  }

  return {
    resultId,
    examId,
    studentId,
    status,
    totalScore,
    startedAt,
    expiresAt,
    score: readNullableInteger(
      data,
      "score",
    ),
    submittedAt: readNullableTimestamp(
      data,
      "submittedAt",
    ),
  };
}

function validateAttemptOwnership(
  attempt: ValidatedAttemptData,
  requestedExamId: string,
  authenticatedStudentId: string,
): void {
  if (attempt.examId !== requestedExamId) {
    throw new HttpsError(
      "permission-denied",
      "The exam attempt does not belong to this exam.",
    );
  }

  if (attempt.studentId !== authenticatedStudentId) {
    throw new HttpsError(
      "permission-denied",
      "The exam attempt does not belong to this student.",
    );
  }
}

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

  const createdAt = readRequiredTimestamp(
    data,
    "createdAt",
  );

  const updatedAt = data.updatedAt instanceof Timestamp ?
    data.updatedAt :
    createdAt;

  return {
    examId,
    gradeId: readRequiredString(
      data,
      "gradeId",
    ),
    examName: readRequiredString(
      data,
      "examName",
    ),
    questionCount: readPositiveInteger(
      data,
      "questionCount",
    ),
    durationMinutes: readPositiveInteger(
      data,
      "durationMinutes",
    ),
    totalScore: readPositiveInteger(
      data,
      "totalScore",
    ),
    examStatus: readRequiredString(
      data,
      "examStatus",
    ),
    createdAt,
    updatedAt,
  };
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

  const questionOrder = readNonNegativeInteger(
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
    questionOrder,
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
    if (!questionIds.add(question.questionId)) {
      throw new HttpsError(
        "data-loss",
        "The exam contains duplicate questions.",
      );
    }

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

function createSafeAttemptResponse(
  attempt: ValidatedAttemptData,
): Record<string, unknown> {
  return {
    resultId: attempt.resultId,
    examId: attempt.examId,
    studentId: attempt.studentId,
    status: attempt.status,
    score: attempt.score,
    totalScore: attempt.totalScore,
    startedAt: attempt.startedAt,
    expiresAt: attempt.expiresAt,
    submittedAt: attempt.submittedAt,
  };
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

function readNullableInteger(
  data: DocumentData,
  key: string,
): number | null {
  const value = data[key];

  if (value === null || value === undefined) {
    return null;
  }

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

function readNullableTimestamp(
  data: DocumentData,
  key: string,
): Timestamp | null {
  const value = data[key];

  if (value === null || value === undefined) {
    return null;
  }

  if (!(value instanceof Timestamp)) {
    throw new HttpsError(
      "data-loss",
      `The ${key} field is invalid.`,
    );
  }

  return value;
}
