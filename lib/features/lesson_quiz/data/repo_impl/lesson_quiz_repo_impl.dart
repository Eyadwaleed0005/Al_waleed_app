import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repos/lesson_quiz_repo.dart';
import 'package:dartz/dartz.dart';

class LessonQuizRepoImpl implements LessonQuizRepository {
  final LessonQuizRemoteDataSource quizRemoteDataSource;

  LessonQuizRepoImpl({required this.quizRemoteDataSource});

  @override
  Future<Either<AppErrorModel, List<LessonQuizEntity>>> getQuizQuestions({
    required String lessonId,
  }) async {
    try {
      final questions = await quizRemoteDataSource.getQuizQuestions(
        lessonId: lessonId,
      );
      return right(questions);
    } on FirebaseRemoteException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(FirebaseErrorHandler.handle(e));
    }
  }
}