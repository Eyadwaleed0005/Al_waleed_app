import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_question_entity.dart';

class StudentExamSessionEntity {
  const StudentExamSessionEntity({
    required this.exam,
    required this.attempt,
    required this.questions,
  });

  final StudentExamEntity exam;
  final StudentExamAttemptEntity attempt;
  final List<StudentExamQuestionEntity> questions;

  bool get hasQuestions => questions.isNotEmpty;
}
