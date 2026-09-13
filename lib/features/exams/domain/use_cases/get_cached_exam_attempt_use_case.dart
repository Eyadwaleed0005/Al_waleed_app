import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedExamAttemptUseCase {
  const GetCachedExamAttemptUseCase({
    required ExamAttemptCacheRepository repository,
  }) : _repository = repository;

  final ExamAttemptCacheRepository _repository;

  Future<Either<AppErrorModel, CachedExamAttemptEntity>> call({
    required String resultId,
  }) async {
    final Either<AppErrorModel, CachedExamAttemptEntity?> result =
        await _repository.getAttempt(resultId: resultId);

    return result.fold(
      (AppErrorModel error) {
        return Left(error);
      },
      (CachedExamAttemptEntity? attempt) {
        if (attempt == null) {
          return Left(LocalStorageErrorHandler.dataNotFound());
        }

        return Right(attempt);
      },
    );
  }
}
