import 'package:al_waleed/features/exams/domain/entities/student_exam_status.dart';

class StudentExamEntity {
  const StudentExamEntity({
    required this.examId,
    required this.gradeId,
    required this.examName,
    required this.questionCount,
    required this.durationMinutes,
    required this.totalScore,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String examId;
  final String gradeId;
  final String examName;
  final int questionCount;
  final int durationMinutes;
  final int totalScore;
  final StudentExamStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPublished => status == StudentExamStatus.published;

  bool get isEnded => status == StudentExamStatus.ended;

  bool isAvailableForGrade(String studentGradeId) {
    return isPublished &&
        gradeId.trim().isNotEmpty &&
        gradeId.trim() == studentGradeId.trim() &&
        questionCount > 0 &&
        durationMinutes > 0 &&
        totalScore > 0;
  }
}
