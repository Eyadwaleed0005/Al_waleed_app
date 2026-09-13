import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:dartz/dartz.dart';

class MarkExpiredExamAttemptsPendingUseCase {
  const MarkExpiredExamAttemptsPendingUseCase({
    required ExamAttemptCacheRepository repository,
  }) : _repository = repository;

  final ExamAttemptCacheRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({DateTime? currentDate}) async {
    final DateTime now = (currentDate ?? DateTime.now()).toUtc();

    final Either<AppErrorModel, List<CachedExamAttemptEntity>> attemptsResult =
        await _repository.getAllAttempts();

    return attemptsResult.fold<Future<Either<AppErrorModel, Unit>>>(
      (AppErrorModel error) async {
        return Left(error);
      },
      (List<CachedExamAttemptEntity> attempts) async {
        for (final CachedExamAttemptEntity attempt in attempts) {
          if (attempt.isPendingSubmission) {
            continue;
          }

          final DateTime expiresAt = attempt.expiresAt.toUtc();

          if (expiresAt.isAfter(now)) {
            continue;
          }

          final Either<AppErrorModel, Unit> markResult = await _repository
              .markPendingSubmission(
                resultId: attempt.resultId,
                isTimeExpired: true,
              );

          final AppErrorModel? markError = markResult.fold<AppErrorModel?>(
            (AppErrorModel error) => error,
            (Unit _) => null,
          );

          if (markError != null) {
            return Left(markError);
          }
        }

        return const Right(unit);
      },
    );
  }
}
