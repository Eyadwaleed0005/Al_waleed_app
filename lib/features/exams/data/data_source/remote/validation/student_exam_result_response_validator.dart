import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';

abstract final class StudentExamResultResponseValidator {
  const StudentExamResultResponseValidator._();

  static void validate({
    required int score,
    required int totalScore,
    required int correctAnswers,
    required int wrongAnswers,
    required int unansweredQuestions,
  }) {
    ExamRemoteResponseValidator.ensurePositive(totalScore);

    ExamRemoteResponseValidator.ensureNotNegative(score);
    ExamRemoteResponseValidator.ensureNotNegative(correctAnswers);
    ExamRemoteResponseValidator.ensureNotNegative(wrongAnswers);
    ExamRemoteResponseValidator.ensureNotNegative(unansweredQuestions);

    if (score > totalScore) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    final int totalQuestions =
        correctAnswers + wrongAnswers + unansweredQuestions;

    if (totalQuestions <= 0) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (correctAnswers == 0 && score != 0) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (correctAnswers > 0 && score == 0) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    final bool allAnswersAreCorrect =
        wrongAnswers == 0 && unansweredQuestions == 0;

    if (allAnswersAreCorrect && score != totalScore) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (score == totalScore && !allAnswersAreCorrect) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }
}
