import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:al_waleed/features/exams/domain/repositories/student_exams_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitStudentExamUseCase {
  const SubmitStudentExamUseCase({
    required StudentExamsRepository studentExamsRepository,
    required ExamAttemptCacheRepository cacheRepository,
  }) : _studentExamsRepository = studentExamsRepository,
       _cacheRepository = cacheRepository;

  final StudentExamsRepository _studentExamsRepository;
  final ExamAttemptCacheRepository _cacheRepository;

  Future<Either<AppErrorModel, StudentExamResultEntity>> call({
    required SubmitStudentExamEntity submission,
  }) async {
    final cachedResult = await _cacheRepository.getAttempt(
      resultId: submission.resultId,
    );

    final AppErrorModel? readError = cachedResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (readError != null) {
      return Left(readError);
    }

    final CachedExamAttemptEntity? cachedAttempt = cachedResult
        .fold<CachedExamAttemptEntity?>((_) => null, (attempt) => attempt);

    if (cachedAttempt != null && cachedAttempt.isSubmissionStopped) {
      final String? savedCode = cachedAttempt.submissionStopCode;
      final String? savedMessage = cachedAttempt.submissionStopMessage;

      if (savedCode != null &&
          savedCode.trim().isNotEmpty &&
          savedMessage != null &&
          savedMessage.trim().isNotEmpty) {
        return Left(
          AppErrorModel(
            code: savedCode,
            message: savedMessage,
            type: AppErrorType.notFound,
            isRetryable: false,
          ),
        );
      }
      return _submitAndHandleResult(submission);
    }

    final Either<AppErrorModel, Unit> pendingResult = await _cacheRepository
        .markPendingSubmission(
          resultId: submission.resultId,
          isTimeExpired: submission.isAutomatic,
        );

    final AppErrorModel? cacheError = pendingResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (cacheError != null) {
      return Left(cacheError);
    }

    return _submitAndHandleResult(submission);
  }

  Future<Either<AppErrorModel, StudentExamResultEntity>> _submitAndHandleResult(
    SubmitStudentExamEntity submission,
  ) async {
    final Either<AppErrorModel, StudentExamResultEntity> submissionResult =
        await _studentExamsRepository.submitExam(submission: submission);

    return submissionResult.fold<
      Future<Either<AppErrorModel, StudentExamResultEntity>>
    >(
      (AppErrorModel error) async {
        if (error.code != 'exam-deleted') {
          return Left(error);
        }

        return _stopDeletedExamSubmission(
          resultId: submission.resultId,
          error: error,
        );
      },
      (StudentExamResultEntity examResult) async {
        final Either<AppErrorModel, Unit> clearResult = await _cacheRepository
            .clearAttempt(resultId: submission.resultId);

        return clearResult.fold<Either<AppErrorModel, StudentExamResultEntity>>(
          (error) => Left(error),
          (_) => Right(examResult),
        );
      },
    );
  }

  Future<Either<AppErrorModel, StudentExamResultEntity>>
  _stopDeletedExamSubmission({
    required String resultId,
    required AppErrorModel error,
  }) async {
    final latestResult = await _cacheRepository.getAttempt(resultId: resultId);

    return latestResult
        .fold<Future<Either<AppErrorModel, StudentExamResultEntity>>>(
          (cacheError) async {
            return Left(cacheError);
          },
          (attempt) async {
            if (attempt == null) {
              return Left(error);
            }

            final CachedExamAttemptEntity stoppedAttempt = attempt.copyWith(
              isSubmissionStopped: true,
              isPendingSubmission: false,
              submissionStopCode: error.code,
              submissionStopMessage: error.message,
              updatedAt: DateTime.now().toUtc(),
            );

            final Either<AppErrorModel, Unit> saveResult =
                await _cacheRepository.saveAttempt(attempt: stoppedAttempt);

            return saveResult
                .fold<Either<AppErrorModel, StudentExamResultEntity>>(
                  (saveError) => Left(saveError),
                  (_) => Left(error),
                );
          },
        );
  }
}
