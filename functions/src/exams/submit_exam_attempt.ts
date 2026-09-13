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
  createExamAnswerId,
  createExamResultId,
  examAttemptStatuses,
  examCallableFunctionOptions,
  examCollections,
  getAuthenticatedStudentId,
  getRequestData,
  getRequiredString,
  handleExamFunctionError,
} from "./exam_functions_helper";

interface SubmittedAnswer {
  questionId: string;
  selectedChoiceIndex: number;
}

interface ValidatedQuestion {
  questionId: string;
  correctOption: number;
  questionScore: number;
}

interface ExamSubmissionResult {
  resultId: string;
  examId: string;
  examName: string;
  score: number;
  totalScore: number;
  correctAnswers: number;
  wrongAnswers: number;
  unansweredQuestions: number;
  submittedAt: Timestamp;
}

interface CalculatedAnswer {
  questionId: string;
  selectedChoiceIndex: number;
  isCorrect: boolean;
  awardedScore: number;
}

interface CalculatedSubmission {
  score: number;
  correctAnswers: number;
  wrongAnswers: number;
  unansweredQuestions: number;
  answers: CalculatedAnswer[];
}

export const submitExamAttempt = onCall(
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

      readRequiredBoolean(
        requestData,
        "isAutomatic",
      );

      const submittedAnswers = readSubmittedAnswers(
        requestData.answers,
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

      const examReference = firestore
        .collection(examCollections.exams)
        .doc(examId);

      const resultReference = firestore
        .collection(examCollections.examResults)
        .doc(resultId);

      const questionsQuery = firestore
        .collection(examCollections.examQuestions)
        .where("examId", "==", examId);

      const result = await firestore.runTransaction(
        async (transaction): Promise<ExamSubmissionResult> => {
          const examSnapshot = await transaction.get(
            examReference,
          );

          const resultSnapshot = await transaction.get(
            resultReference,
          );

          if (!examSnapshot.exists) {
            throw new HttpsError(
              "not-found",
              "The requested exam does not exist.",
            );
          }

          if (!resultSnapshot.exists) {
            throw new HttpsError(
              "not-found",
              "The exam attempt does not exist.",
            );
          }

          const examData = examSnapshot.data();
          const attemptData = resultSnapshot.data();

          if (examData === undefined) {
            throw new HttpsError(
              "data-loss",
              "The exam data is unavailable.",
            );
          }

          if (attemptData === undefined) {
            throw new HttpsError(
              "data-loss",
              "The exam attempt data is unavailable.",
            );
          }

          validateAttemptOwnership(
            attemptData,
            resultId,
            examId,
            studentId,
          );

          const examName = readRequiredString(
            examData,
            "examName",
          );

          const examQuestionCount = readPositiveInteger(
            examData,
            "questionCount",
          );

          const examTotalScore = readPositiveInteger(
            examData,
            "totalScore",
          );

          const attemptTotalScore = readPositiveInteger(
            attemptData,
            "totalScore",
          );

          if (attemptTotalScore !== examTotalScore) {
            throw new HttpsError(
              "data-loss",
              "The exam attempt score data is inconsistent.",
            );
          }

          const attemptStatus = readRequiredString(
            attemptData,
            "status",
          );

          if (
            attemptStatus ===
            examAttemptStatuses.submitted
          ) {
            return readExistingSubmissionResult(
              attemptData,
              resultId,
              examId,
              examName,
              examTotalScore,
            );
          }

          if (
            attemptStatus !==
            examAttemptStatuses.inProgress
          ) {
            throw new HttpsError(
              "failed-precondition",
              "The exam attempt cannot be submitted.",
            );
          }

          const questionsSnapshot = await transaction.get(
            questionsQuery,
          );

          const questions = questionsSnapshot.docs.map(
            (questionDocument) => {
              return validateQuestion(
                questionDocument.id,
                questionDocument.data(),
                examId,
              );
            },
          );

          validateQuestions(
            questions,
            examQuestionCount,
            examTotalScore,
          );

          const calculatedSubmission =
            calculateSubmission(
              submittedAnswers,
              questions,
            );

          const submittedAt = Timestamp.now();

          for (
            const answer of calculatedSubmission.answers
          ) {
            const answerId = createExamAnswerId(
              resultId,
              answer.questionId,
            );

            const answerReference = firestore
              .collection(
                examCollections.examAttemptAnswers,
              )
              .doc(answerId);

            transaction.set(
              answerReference,
              {
                answerId,
                examId,
                resultId,
                questionId: answer.questionId,
                studentId,
                selectedChoiceIndex:
                  answer.selectedChoiceIndex,
                isCorrect: answer.isCorrect,
                awardedScore: answer.awardedScore,
                answeredAt: submittedAt,
                createdAt: submittedAt,
                updatedAt: submittedAt,
              },
            );
          }

          transaction.update(
            resultReference,
            {
              status: examAttemptStatuses.submitted,
              score: calculatedSubmission.score,
              correctAnswers:
                calculatedSubmission.correctAnswers,
              wrongAnswers:
                calculatedSubmission.wrongAnswers,
              unansweredQuestions:
                calculatedSubmission.unansweredQuestions,
              submittedAt,
              updatedAt: submittedAt,
            },
          );

          return {
            resultId,
            examId,
            examName,
            score: calculatedSubmission.score,
            totalScore: examTotalScore,
            correctAnswers:
              calculatedSubmission.correctAnswers,
            wrongAnswers:
              calculatedSubmission.wrongAnswers,
            unansweredQuestions:
              calculatedSubmission.unansweredQuestions,
            submittedAt,
          };
        },
      );

      return {
        result,
      };
    } catch (error) {
      handleExamFunctionError(
        error,
        "submitExamAttempt",
      );
    }
  },
);

function readSubmittedAnswers(
  value: unknown,
): SubmittedAnswer[] {
  if (!Array.isArray(value)) {
    throw new HttpsError(
      "invalid-argument",
      "answers must be a list.",
    );
  }

  const answers = value.map(
    (rawAnswer): SubmittedAnswer => {
      if (
        typeof rawAnswer !== "object" ||
        rawAnswer === null ||
        Array.isArray(rawAnswer)
      ) {
        throw new HttpsError(
          "invalid-argument",
          "An exam answer is invalid.",
        );
      }

      const answerData =
        rawAnswer as Record<string, unknown>;

      const questionId = getRequiredString(
        answerData,
        "questionId",
      );

      const selectedChoiceIndex =
        answerData.selectedChoiceIndex;

      if (
        typeof selectedChoiceIndex !== "number" ||
        !Number.isInteger(selectedChoiceIndex) ||
        selectedChoiceIndex < 0 ||
        selectedChoiceIndex > 3
      ) {
        throw new HttpsError(
          "invalid-argument",
          "selectedChoiceIndex must be between 0 and 3.",
        );
      }

      return {
        questionId,
        selectedChoiceIndex,
      };
    },
  );

  const questionIds = new Set<string>();

  for (const answer of answers) {
    if (!questionIds.add(answer.questionId)) {
      throw new HttpsError(
        "invalid-argument",
        "Duplicate answers are not allowed.",
      );
    }
  }

  if (answers.length > 499) {
    throw new HttpsError(
      "resource-exhausted",
      "The submission contains too many answers.",
    );
  }

  return answers;
}

function validateAttemptOwnership(
  attemptData: DocumentData,
  requestedResultId: string,
  requestedExamId: string,
  authenticatedStudentId: string,
): void {
  const storedResultId = readRequiredString(
    attemptData,
    "resultId",
  );

  const storedExamId = readRequiredString(
    attemptData,
    "examId",
  );

  const storedStudentId = readRequiredString(
    attemptData,
    "studentId",
  );

  if (storedResultId !== requestedResultId) {
    throw new HttpsError(
      "permission-denied",
      "The exam attempt identifier is invalid.",
    );
  }

  if (storedExamId !== requestedExamId) {
    throw new HttpsError(
      "permission-denied",
      "The exam attempt does not belong to this exam.",
    );
  }

  if (storedStudentId !== authenticatedStudentId) {
    throw new HttpsError(
      "permission-denied",
      "The exam attempt does not belong to this student.",
    );
  }
}

function validateQuestion(
  questionId: string,
  questionData: DocumentData,
  examId: string,
): ValidatedQuestion {
  const questionExamId = readRequiredString(
    questionData,
    "examId",
  );

  if (questionExamId !== examId) {
    throw new HttpsError(
      "data-loss",
      "An exam question belongs to another exam.",
    );
  }

  const correctOption = readNonNegativeInteger(
    questionData,
    "correctOption",
  );

  if (correctOption > 3) {
    throw new HttpsError(
      "data-loss",
      "An exam question has an invalid correct option.",
    );
  }

  const questionScore = readPositiveInteger(
    questionData,
    "questionScore",
  );

  return {
    questionId,
    correctOption,
    questionScore,
  };
}

function validateQuestions(
  questions: ValidatedQuestion[],
  examQuestionCount: number,
  examTotalScore: number,
): void {
  if (questions.length !== examQuestionCount) {
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

    calculatedTotalScore += question.questionScore;
  }

  if (calculatedTotalScore !== examTotalScore) {
    throw new HttpsError(
      "failed-precondition",
      "The exam total score does not match its questions.",
    );
  }
}

function calculateSubmission(
  submittedAnswers: SubmittedAnswer[],
  questions: ValidatedQuestion[],
): CalculatedSubmission {
  const questionsById = new Map<
    string,
    ValidatedQuestion
  >();

  for (const question of questions) {
    questionsById.set(
      question.questionId,
      question,
    );
  }

  const calculatedAnswers: CalculatedAnswer[] = [];
  let score = 0;
  let correctAnswers = 0;
  let wrongAnswers = 0;

  for (const submittedAnswer of submittedAnswers) {
    const question = questionsById.get(
      submittedAnswer.questionId,
    );

    if (question === undefined) {
      throw new HttpsError(
        "invalid-argument",
        "An answer refers to an unknown exam question.",
      );
    }

    const isCorrect =
      submittedAnswer.selectedChoiceIndex ===
      question.correctOption;

    const awardedScore = isCorrect ?
      question.questionScore :
      0;

    if (isCorrect) {
      correctAnswers += 1;
      score += awardedScore;
    } else {
      wrongAnswers += 1;
    }

    calculatedAnswers.push({
      questionId: submittedAnswer.questionId,
      selectedChoiceIndex:
        submittedAnswer.selectedChoiceIndex,
      isCorrect,
      awardedScore,
    });
  }

  return {
    score,
    correctAnswers,
    wrongAnswers,
    unansweredQuestions:
      questions.length - submittedAnswers.length,
    answers: calculatedAnswers,
  };
}

function readExistingSubmissionResult(
  attemptData: DocumentData,
  resultId: string,
  examId: string,
  examName: string,
  totalScore: number,
): ExamSubmissionResult {
  const score = readNonNegativeInteger(
    attemptData,
    "score",
  );

  const correctAnswers = readNonNegativeInteger(
    attemptData,
    "correctAnswers",
  );

  const wrongAnswers = readNonNegativeInteger(
    attemptData,
    "wrongAnswers",
  );

  const unansweredQuestions =
    readNonNegativeInteger(
      attemptData,
      "unansweredQuestions",
    );

  const submittedAt = readRequiredTimestamp(
    attemptData,
    "submittedAt",
  );

  if (score > totalScore) {
    throw new HttpsError(
      "data-loss",
      "The stored exam score is invalid.",
    );
  }

  return {
    resultId,
    examId,
    examName,
    score,
    totalScore,
    correctAnswers,
    wrongAnswers,
    unansweredQuestions,
    submittedAt,
  };
}

function readRequiredBoolean(
  data: Record<string, unknown>,
  key: string,
): boolean {
  const value = data[key];

  if (typeof value !== "boolean") {
    throw new HttpsError(
      "invalid-argument",
      `${key} must be a boolean.`,
    );
  }

  return value;
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
