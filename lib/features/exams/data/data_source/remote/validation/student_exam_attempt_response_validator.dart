import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_status.dart';

abstract final class StudentExamAttemptResponseValidator {
  const StudentExamAttemptResponseValidator._();

  static StudentExamAttemptStatus readStatus({
    required dynamic value,
    required int? score,
    required DateTime? submittedAt,
  }) {
    final String normalizedStatus =
        value?.toString().trim().toLowerCase() ?? '';

    switch (normalizedStatus) {
      case 'inprogress':
        if (score != null || submittedAt != null) {
          FirebaseErrorHandler.throwFirestoreCode('data-loss');
        }

        return StudentExamAttemptStatus.inProgress;

      case 'submitted':
        if (score == null || submittedAt == null) {
          FirebaseErrorHandler.throwFirestoreCode('data-loss');
        }

        return StudentExamAttemptStatus.submitted;

      default:
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }
}
