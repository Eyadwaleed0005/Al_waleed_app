import 'package:al_waleed/features/exams/domain/entities/student_exam_answer_entity.dart';

class SubmitStudentExamEntity {
  const SubmitStudentExamEntity({
    required this.examId,
    required this.resultId,
    required this.answers,
    required this.isAutomatic,
  });

  final String examId;
  final String resultId;
  final List<StudentExamAnswerEntity> answers;

  final bool isAutomatic;

  int get answeredQuestionsCount {
    return answers.length;
  }

  bool get hasAnswers {
    return answers.isNotEmpty;
  }
}
