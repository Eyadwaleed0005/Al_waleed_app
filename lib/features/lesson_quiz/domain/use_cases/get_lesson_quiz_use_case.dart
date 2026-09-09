import 'package:al_waleed/features/lesson_quiz/domain/entities/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repositories/lesson_quiz_repository.dart';

class GetLessonQuizUseCase {
  const GetLessonQuizUseCase(this._repository);

  final LessonQuizRepository _repository;

  Future<LessonQuizEntity> call() async {
    return await _repository.getLessonQuiz();
  }
}
