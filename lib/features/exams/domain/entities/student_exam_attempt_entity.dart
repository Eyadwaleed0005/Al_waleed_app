import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_status.dart';

class StudentExamAttemptEntity {
  const StudentExamAttemptEntity({
    required this.resultId,
    required this.examId,
    required this.studentId,
    required this.status,
    required this.totalScore,
    required this.startedAt,
    required this.expiresAt,
    this.score,
    this.submittedAt,
  });

  final String resultId;
  final String examId;
  final String studentId;
  final StudentExamAttemptStatus status;
  final int totalScore;
  final DateTime startedAt;
  final DateTime expiresAt;
  final int? score;
  final DateTime? submittedAt;

  bool get isInProgress => status == StudentExamAttemptStatus.inProgress;

  bool get isSubmitted => status == StudentExamAttemptStatus.submitted;

  bool isExpiredAt(DateTime currentDate) {
    return !currentDate.toUtc().isBefore(expiresAt.toUtc());
  }

  bool canContinueAt(DateTime currentDate) {
    return isInProgress && !isExpiredAt(currentDate);
  }

  bool shouldAutoSubmitAt(DateTime currentDate) {
    return isInProgress && isExpiredAt(currentDate);
  }

  Duration remainingDurationAt(DateTime currentDate) {
    if (!canContinueAt(currentDate)) {
      return Duration.zero;
    }

    return expiresAt.toUtc().difference(currentDate.toUtc());
  }
}
