import 'package:al_waleed/features/lesson_quiz/domain/entities/lesson_quiz_entity.dart';

abstract class LessonQuizRepository {
  Future<LessonQuizEntity> getLessonQuiz();
}
