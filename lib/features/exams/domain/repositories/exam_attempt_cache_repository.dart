import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ExamAttemptCacheRepository {
  Future<Either<AppErrorModel, CachedExamAttemptEntity?>> getAttempt({
    required String resultId,
  });

  Future<Either<AppErrorModel, List<CachedExamAttemptEntity>>> getAllAttempts();

  Future<Either<AppErrorModel, List<CachedExamAttemptEntity>>>
  getPendingSubmissions();

  Future<Either<AppErrorModel, Unit>> saveAttempt({
    required CachedExamAttemptEntity attempt,
  });

  Future<Either<AppErrorModel, Unit>> saveAnswer({
    required String resultId,
    required String questionId,
    required int? selectedChoiceIndex,
  });

  Future<Either<AppErrorModel, Unit>> markPendingSubmission({
    required String resultId,
    required bool isTimeExpired,
  });

  Future<Either<AppErrorModel, Unit>> clearAttempt({required String resultId});
}
