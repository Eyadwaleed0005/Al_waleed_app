import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:dartz/dartz.dart';

class GetPendingExamSubmissionsUseCase {
  const GetPendingExamSubmissionsUseCase({
    required ExamAttemptCacheRepository repository,
  }) : _repository = repository;

  final ExamAttemptCacheRepository _repository;

  Future<Either<AppErrorModel, List<CachedExamAttemptEntity>>> call() {
    return _repository.getPendingSubmissions();
  }
}
