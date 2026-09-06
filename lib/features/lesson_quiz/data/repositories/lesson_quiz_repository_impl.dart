import 'package:al_waleed/features/lesson_quiz/data/data_sources/lesson_quiz_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entities/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repositories/lesson_quiz_repository.dart';

class LessonQuizRepositoryImpl implements LessonQuizRepository {
  const LessonQuizRepositoryImpl(this._dataSource);

  final LessonQuizDataSource _dataSource;

  @override
  Future<LessonQuizEntity> getLessonQuiz() async {
    return await _dataSource.getLessonQuiz();
  }
}
