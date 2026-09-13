import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:dartz/dartz.dart';

class ClearCachedExamAttemptUseCase {
  const ClearCachedExamAttemptUseCase({
    required ExamAttemptCacheRepository repository,
  }) : _repository = repository;

  final ExamAttemptCacheRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({required String resultId}) {
    return _repository.clearAttempt(resultId: resultId);
  }
}
