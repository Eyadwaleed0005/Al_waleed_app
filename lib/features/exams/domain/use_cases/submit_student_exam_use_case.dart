import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
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
    final Either<AppErrorModel, Unit> pendingResult = await _cacheRepository
        .markPendingSubmission(
          resultId: submission.resultId,
          isTimeExpired: submission.isAutomatic,
        );

    final AppErrorModel? cacheError = pendingResult.fold<AppErrorModel?>(
      (AppErrorModel error) {
        return error;
      },
      (Unit _) {
        return null;
      },
    );

    if (cacheError != null) {
      return Left(cacheError);
    }

    final Either<AppErrorModel, StudentExamResultEntity> submissionResult =
        await _studentExamsRepository.submitExam(submission: submission);

    return submissionResult
        .fold<Future<Either<AppErrorModel, StudentExamResultEntity>>>(
          (AppErrorModel error) async {
            return Left(error);
          },
          (StudentExamResultEntity examResult) async {
            final Either<AppErrorModel, Unit> clearResult =
                await _cacheRepository.clearAttempt(
                  resultId: submission.resultId,
                );

            return clearResult.fold(
              (AppErrorModel error) {
                return Left(error);
              },
              (Unit _) {
                return Right(examResult);
              },
            );
          },
        );
  }
}
