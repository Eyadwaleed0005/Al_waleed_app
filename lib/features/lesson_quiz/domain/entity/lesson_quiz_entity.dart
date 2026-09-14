import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_question_entity.dart';

class LessonQuizEntity {
  final String lessonId;
  final List<LessonQuizQuestionEntity> questions;

  const LessonQuizEntity({
    required this.lessonId,
    required this.questions,
  });

  int get totalScore {
    return questions.fold(
      0,
      (total, question) => total + question.score,
    );
  }
}