import {
  DocumentData,
  Firestore,
  Timestamp,
} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {HttpsError} from "firebase-functions/v2/https";
export const examCallableFunctionOptions = {
  region: "us-central1",
  memory: "256MiB" as const,
  cpu: "gcf_gen1" as const,
  timeoutSeconds: 60,
  minInstances: 0,
  maxInstances: 10,
};

export const examCollections = {
  students: "students",
  grades: "grades",
  exams: "exams",
  examQuestions: "examQuestions",
  examResults: "examResults",
  examAttemptAnswers: "examAttemptAnswers",
} as const;

export const examStatuses = {
  published: "published",
} as const;

export const examAttemptStatuses = {
  inProgress: "inProgress",
  submitted: "submitted",
} as const;

export interface AuthenticatedStudent {
  studentId: string;
  studentName: string;
  gradeId: string;
  gradeName: string;
}

interface CallableAuth {
  uid: string;
}

export function getAuthenticatedStudentId(
  auth: CallableAuth | undefined,
): string {
  if (
    auth === undefined ||
    typeof auth.uid !== "string" ||
    auth.uid.trim().length === 0
  ) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to perform this operation.",
    );
  }

  return auth.uid;
}

export function getRequestData(
  data: unknown,
): Record<string, unknown> {
  if (
    typeof data !== "object" ||
    data === null ||
    Array.isArray(data)
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Request data is invalid.",
    );
  }

  return data as Record<string, unknown>;
}

export function getRequiredString(
  data: Record<string, unknown>,
  key: string,
): string {
  const value = data[key];

  if (
    typeof value !== "string" ||
    value.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      `${key} is required.`,
    );
  }

  return value.trim();
}

export function createExamResultId(
  examId: string,
  studentId: string,
): string {
  return `${examId}_${studentId}`;
}

export function createExamAnswerId(
  resultId: string,
  questionId: string,
): string {
  return `${resultId}_${questionId}`;
}

export async function getAuthenticatedStudent(
  firestore: Firestore,
  studentId: string,
): Promise<AuthenticatedStudent> {
  const studentDocument = await firestore
    .collection(examCollections.students)
    .doc(studentId)
    .get();

  if (!studentDocument.exists) {
    throw new HttpsError(
      "not-found",
      "The student account does not exist.",
    );
  }

  const studentData = studentDocument.data();

  if (studentData === undefined) {
    throw new HttpsError(
      "data-loss",
      "The student account data is unavailable.",
    );
  }

  const storedStudentId = studentData.studentId;
  const studentName = studentData.name;
  const gradeId = studentData.gradeId;
  const isActive = studentData.isActive;
  const subscriptionEndAt = studentData.subscriptionEndAt;

  if (
    typeof storedStudentId !== "string" ||
    storedStudentId !== studentId
  ) {
    throw new HttpsError(
      "permission-denied",
      "The student account identity is invalid.",
    );
  }

  if (
    typeof studentName !== "string" ||
    studentName.trim().length === 0
  ) {
    throw new HttpsError(
      "failed-precondition",
      "The student name is invalid.",
    );
  }

  if (
    typeof gradeId !== "string" ||
    gradeId.trim().length === 0
  ) {
    throw new HttpsError(
      "failed-precondition",
      "The student grade is invalid.",
    );
  }

  if (isActive !== true) {
    throw new HttpsError(
      "permission-denied",
      "The student account is inactive.",
    );
  }

  if (!(subscriptionEndAt instanceof Timestamp)) {
    throw new HttpsError(
      "failed-precondition",
      "The student subscription end date is invalid.",
    );
  }

  if (
    subscriptionEndAt.toMillis() <=
    Timestamp.now().toMillis()
  ) {
    throw new HttpsError(
      "permission-denied",
      "The student subscription has expired.",
    );
  }

  const gradeDocument = await firestore
    .collection(examCollections.grades)
    .doc(gradeId)
    .get();

  if (!gradeDocument.exists) {
    throw new HttpsError(
      "failed-precondition",
      "The student grade does not exist.",
    );
  }

  const gradeData = gradeDocument.data();

  if (gradeData === undefined) {
    throw new HttpsError(
      "data-loss",
      "The student grade data is unavailable.",
    );
  }

  const gradeName = gradeData.name;
  const isGradeActive = gradeData.isActive;

  if (
    typeof gradeName !== "string" ||
    gradeName.trim().length === 0
  ) {
    throw new HttpsError(
      "failed-precondition",
      "The student grade name is invalid.",
    );
  }

  if (isGradeActive !== true) {
    throw new HttpsError(
      "failed-precondition",
      "The student grade is inactive.",
    );
  }

  return {
    studentId,
    studentName: studentName.trim(),
    gradeId: gradeId.trim(),
    gradeName: gradeName.trim(),
  };
}

export function createSafeQuestionData(
  questionId: string,
  questionData: DocumentData,
): Record<string, unknown> {
  return {
    questionId,
    examId: questionData.examId,
    questionText: questionData.questionText,
    questionImageUrl: questionData.questionImageUrl ?? null,
    option1: questionData.option1,
    option2: questionData.option2,
    option3: questionData.option3,
    option4: questionData.option4,
    questionScore: questionData.questionScore,
    questionOrder: questionData.questionOrder,
  };
}

export function handleExamFunctionError(
  error: unknown,
  operation: string,
): never {
  if (error instanceof HttpsError) {
    logger.warn(
      "Exam function request rejected.",
      {
        operation,
        errorCode: error.code,
        errorMessage: error.message,
        errorDetails: error.details ?? null,
      },
    );

    throw error;
  }

  const errorCode = getErrorCode(error);
  const errorMessage = getErrorMessage(error);

  logger.error(
    "Unhandled exam function error.",
    {
      operation,
      errorCode,
      errorMessage,
    },
  );

  throw new HttpsError(
    "internal",
    "The exam operation could not be completed.",
  );
}

function getErrorCode(
  error: unknown,
): string {
  if (
    typeof error === "object" &&
    error !== null &&
    "code" in error
  ) {
    return String(error.code);
  }

  return "";
}

function getErrorMessage(
  error: unknown,
): string {
  if (
    typeof error === "object" &&
    error !== null &&
    "message" in error
  ) {
    return String(error.message);
  }

  return "Unknown error.";
}
