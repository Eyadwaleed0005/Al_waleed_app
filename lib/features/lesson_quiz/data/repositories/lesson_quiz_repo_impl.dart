import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repositories/lesson_quiz_repo.dart';
import 'package:dartz/dartz.dart';

class LessonQuizRepositoryImpl implements LessonQuizRepository {
  final LessonQuizRemoteDataSource _remoteDataSource;

  const LessonQuizRepositoryImpl({
    required LessonQuizRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<AppErrorModel, LessonQuizEntity>> getLessonQuiz({
    required String lessonId,
  }) async {
    try {
      final questions = await _remoteDataSource.getQuizQuestions(
        lessonId: lessonId,
      );

      final lessonQuiz = LessonQuizEntity(
        lessonId: lessonId,
        questions: questions,
      );

      return right(lessonQuiz);
    } on FirebaseRemoteException catch (error) {
      return left(error.errorModel);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }
}