import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/lessons_local_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/lessons_remote_data_source.dart';
import 'package:al_waleed/features/lessons/data/models/lesson_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  final LessonsLocalDataSource localDataSource;
  final LessonsRemoteDataSource remoteDataSource;

  const LessonsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<AppErrorModel, LessonEntity>> getLessonById({
    required String lessonId,
  }) async {
    final gradeResult = await _getRequiredGradeId();

    final gradeError = gradeResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (gradeError != null) {
      return Left(gradeError);
    }

    final gradeId = gradeResult.getOrElse(() => '');

    try {
      final lesson = await remoteDataSource.getLessonById(
        lessonId: lessonId,
        gradeId: gradeId,
      );

      return Right(lesson);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Stream<Either<AppErrorModel, List<LessonEntity>>> streamLessons() async* {
    final gradeResult = await _getRequiredGradeId();

    final gradeError = gradeResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (gradeError != null) {
      yield Left(gradeError);
      return;
    }

    final gradeId = gradeResult.getOrElse(() => '');

    try {
      await for (final models in remoteDataSource.streamLessons(
        gradeId: gradeId,
      )) {
        yield Right(_mapModelsToEntities(models));
      }
    } on FirebaseRemoteException catch (error) {
      yield Left(error.errorModel);
    } catch (error) {
      yield Left(FirebaseErrorHandler.handle(error));
    }
  }

  Future<Either<AppErrorModel, String>> _getRequiredGradeId() async {
    try {
      final storedGradeId = await localDataSource.getGradeId();
      final gradeId = storedGradeId?.trim() ?? '';

      if (gradeId.isEmpty) {
        return Left(LocalStorageErrorHandler.dataNotFound());
      }

      return Right(gradeId);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  List<LessonEntity> _mapModelsToEntities(List<LessonModel> models) {
    return List<LessonEntity>.unmodifiable(models);
  }
}