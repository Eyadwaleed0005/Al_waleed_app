import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:al_waleed/features/exams/domain/repositories/student_exams_repository.dart';
import 'package:al_waleed/features/exams/domain/validation/exam_session_cache_compatibility_validator.dart';
import 'package:dartz/dartz.dart';

class ResumeStudentExamUseCase {
  const ResumeStudentExamUseCase({
    required this._studentExamsRepository,
    required this._cacheRepository,
  });

  final StudentExamsRepository _studentExamsRepository;
  final ExamAttemptCacheRepository _cacheRepository;

  Future<Either<AppErrorModel, StudentExamSessionEntity>> call({
    required String examId,
    required String resultId,
  }) async {
    final Either<AppErrorModel, StudentExamSessionEntity> sessionResult =
        await _studentExamsRepository.resumeExam(
          examId: examId,
          resultId: resultId,
        );

    return sessionResult
        .fold<Future<Either<AppErrorModel, StudentExamSessionEntity>>>(
          (AppErrorModel error) async {
            return Left(error);
          },
          (StudentExamSessionEntity session) async {
            final Either<AppErrorModel, CachedExamAttemptEntity?> cachedResult =
                await _cacheRepository.getAttempt(
                  resultId: session.attempt.resultId,
                );

            return cachedResult
                .fold<Future<Either<AppErrorModel, StudentExamSessionEntity>>>(
                  (AppErrorModel error) async {
                    return Left(error);
                  },
                  (CachedExamAttemptEntity? cachedAttempt) async {
                    if (cachedAttempt != null) {
                      return _validateCachedAttempt(
                        session: session,
                        cachedAttempt: cachedAttempt,
                      );
                    }

                    final CachedExamAttemptEntity newCachedAttempt =
                        _createCachedAttempt(session);

                    final Either<AppErrorModel, Unit> saveResult =
                        await _cacheRepository.saveAttempt(
                          attempt: newCachedAttempt,
                        );

                    return saveResult.fold(
                      (AppErrorModel error) {
                        return Left(error);
                      },
                      (Unit _) {
                        return Right(session);
                      },
                    );
                  },
                );
          },
        );
  }

  Either<AppErrorModel, StudentExamSessionEntity> _validateCachedAttempt({
    required StudentExamSessionEntity session,
    required CachedExamAttemptEntity cachedAttempt,
  }) {
    final Either<AppErrorModel, Unit> validationResult =
        ExamSessionCacheCompatibilityValidator.validate(
          session: session,
          cachedAttempt: cachedAttempt,
        );

    return validationResult.fold(
      (AppErrorModel error) {
        return Left(error);
      },
      (Unit _) {
        return Right(session);
      },
    );
  }

  CachedExamAttemptEntity _createCachedAttempt(
    StudentExamSessionEntity session,
  ) {
    return CachedExamAttemptEntity(
      resultId: session.attempt.resultId,
      examId: session.exam.examId,
      questionIds: List<String>.unmodifiable(
        session.questions.map((question) => question.questionId),
      ),
      selectedChoiceIndexes: const <String, int>{},
      startedAt: session.attempt.startedAt,
      expiresAt: session.attempt.expiresAt,
      isTimeExpired: false,
      isPendingSubmission: false,
      updatedAt: DateTime.now().toUtc(),
    );
  }
}
