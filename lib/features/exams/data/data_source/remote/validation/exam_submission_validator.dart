import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_identifier_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_answer_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';

abstract final class ExamSubmissionValidator {
  const ExamSubmissionValidator._();

  static void validate(SubmitStudentExamEntity submission) {
    ExamRemoteIdentifierValidator.validate(submission.examId);

    ExamRemoteIdentifierValidator.validate(submission.resultId);

    final Set<String> questionIds = <String>{};

    for (final StudentExamAnswerEntity answer in submission.answers) {
      final String questionId = ExamRemoteIdentifierValidator.validate(
        answer.questionId,
      );
      if (!questionIds.add(questionId)) {
        FirebaseErrorHandler.throwFunctionsCode('invalid-argument');
      }
      if (!answer.hasValidChoiceIndex) {
        FirebaseErrorHandler.throwFunctionsCode('invalid-argument');
      }
    }
  }
}
