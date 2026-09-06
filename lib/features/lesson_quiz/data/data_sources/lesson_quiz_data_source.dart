import 'package:al_waleed/features/lesson_quiz/data/models/lesson_quiz_model.dart';

abstract class LessonQuizDataSource {
  Future<LessonQuizModel> getLessonQuiz();
}
