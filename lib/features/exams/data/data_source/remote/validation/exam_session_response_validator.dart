import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_question_entity.dart';

abstract final class ExamSessionResponseValidator {
  const ExamSessionResponseValidator._();

  static void validate({
    required StudentExamEntity exam,
    required StudentExamAttemptEntity attempt,
    required List<StudentExamQuestionEntity> questions,
  }) {
    if (exam.examId != attempt.examId) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (attempt.totalScore != exam.totalScore) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (questions.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (questions.length != exam.questionCount) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    final Set<String> questionIds = <String>{};
    final Set<int> questionOrders = <int>{};

    int questionsTotalScore = 0;

    for (final StudentExamQuestionEntity question in questions) {
      if (question.examId != exam.examId) {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }

      if (!questionIds.add(question.questionId)) {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }

      if (!questionOrders.add(question.questionOrder)) {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }

      questionsTotalScore += question.degree;
    }

    if (questionsTotalScore != exam.totalScore) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }
}
