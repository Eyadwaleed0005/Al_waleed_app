import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:al_waleed/features/exams/domain/use_cases/mark_expired_exam_attempts_pending_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/submit_student_exam_use_case.dart';
import 'package:dartz/dartz.dart';

class RetryPendingExamSubmissionsUseCase {
  const RetryPendingExamSubmissionsUseCase({
    required ExamAttemptCacheRepository cacheRepository,
    required MarkExpiredExamAttemptsPendingUseCase
    markExpiredExamAttemptsPendingUseCase,
    required SubmitStudentExamUseCase submitStudentExamUseCase,
  }) : _cacheRepository = cacheRepository,
       _markExpiredExamAttemptsPendingUseCase =
           markExpiredExamAttemptsPendingUseCase,
       _submitStudentExamUseCase = submitStudentExamUseCase;

  final ExamAttemptCacheRepository _cacheRepository;

  final MarkExpiredExamAttemptsPendingUseCase
  _markExpiredExamAttemptsPendingUseCase;

  final SubmitStudentExamUseCase _submitStudentExamUseCase;

  Future<Either<AppErrorModel, Unit>> call() async {
    final Either<AppErrorModel, Unit> preparationResult =
        await _markExpiredExamAttemptsPendingUseCase();

    final AppErrorModel? preparationError = preparationResult
        .fold<AppErrorModel?>((AppErrorModel error) => error, (Unit _) => null);

    if (preparationError != null) {
      return Left(preparationError);
    }

    final Either<AppErrorModel, List<CachedExamAttemptEntity>> pendingResult =
        await _cacheRepository.getPendingSubmissions();

    return pendingResult.fold<Future<Either<AppErrorModel, Unit>>>(
      (AppErrorModel error) async {
        return Left(error);
      },
      (List<CachedExamAttemptEntity> attempts) async {
        AppErrorModel? firstError;

        for (final CachedExamAttemptEntity attempt in attempts) {
          final SubmitStudentExamEntity submission = attempt.toSubmission(
            isAutomatic: attempt.isTimeExpired,
          );

          final result = await _submitStudentExamUseCase(
            submission: submission,
          );

          result.fold((AppErrorModel error) {
            firstError ??= error;
          }, (_) {});
        }

        final AppErrorModel? submissionError = firstError;

        if (submissionError != null) {
          return Left(submissionError);
        }

        return const Right(unit);
      },
    );
  }
}
