import 'package:al_waleed/features/lesson_quiz/domain/entities/quiz_question_entity.dart';

/// Top-level quiz entity grouping metadata with its list of questions.
class LessonQuizEntity {
  const LessonQuizEntity({
    required this.id,
    required this.title,
    required this.questions,
  });

  final String id;
  final String title;
  final List<QuizQuestionEntity> questions;
}
