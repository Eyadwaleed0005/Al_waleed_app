import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/exam_attempt_cache_data_source.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:dartz/dartz.dart';

class ExamAttemptCacheRepositoryImpl implements ExamAttemptCacheRepository {
  const ExamAttemptCacheRepositoryImpl({
    required ExamAttemptCacheDataSource cacheDataSource,
  }) : _cacheDataSource = cacheDataSource;

  final ExamAttemptCacheDataSource _cacheDataSource;

  @override
  Future<Either<AppErrorModel, CachedExamAttemptEntity?>> getAttempt({
    required String resultId,
  }) async {
    try {
      final CachedExamAttemptEntity? attempt = await _cacheDataSource
          .getAttempt(resultId: resultId);

      return Right(attempt);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, List<CachedExamAttemptEntity>>>
  getAllAttempts() async {
    try {
      final List<CachedExamAttemptEntity> attempts = await _cacheDataSource
          .getAllAttempts();

      return Right(List<CachedExamAttemptEntity>.unmodifiable(attempts));
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, List<CachedExamAttemptEntity>>>
  getPendingSubmissions() async {
    try {
      final List<CachedExamAttemptEntity> pendingAttempts =
          await _cacheDataSource.getPendingSubmissions();

      return Right(List<CachedExamAttemptEntity>.unmodifiable(pendingAttempts));
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> saveAttempt({
    required CachedExamAttemptEntity attempt,
  }) async {
    try {
      await _cacheDataSource.saveAttempt(attempt: attempt);

      return const Right(unit);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> saveAnswer({
    required String resultId,
    required String questionId,
    required int? selectedChoiceIndex,
  }) async {
    try {
      await _cacheDataSource.saveAnswer(
        resultId: resultId,
        questionId: questionId,
        selectedChoiceIndex: selectedChoiceIndex,
      );

      return const Right(unit);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> markPendingSubmission({
    required String resultId,
    required bool isTimeExpired,
  }) async {
    try {
      await _cacheDataSource.markPendingSubmission(
        resultId: resultId,
        isTimeExpired: isTimeExpired,
      );

      return const Right(unit);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> clearAttempt({
    required String resultId,
  }) async {
    try {
      await _cacheDataSource.clearAttempt(resultId: resultId);

      return const Right(unit);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }
}
