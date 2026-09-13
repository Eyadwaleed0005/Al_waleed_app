import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:al_waleed/features/exams/domain/repositories/student_exams_repository.dart';
import 'package:dartz/dartz.dart';

class StartStudentExamUseCase {
  const StartStudentExamUseCase({
    required StudentExamsRepository studentExamsRepository,
    required ExamAttemptCacheRepository cacheRepository,
  }) : _studentExamsRepository = studentExamsRepository,
       _cacheRepository = cacheRepository;

  final StudentExamsRepository _studentExamsRepository;
  final ExamAttemptCacheRepository _cacheRepository;

  Future<Either<AppErrorModel, StudentExamSessionEntity>> call({
    required String examId,
  }) async {
    final Either<AppErrorModel, StudentExamSessionEntity> sessionResult =
        await _studentExamsRepository.startExam(examId: examId);

    return sessionResult
        .fold<Future<Either<AppErrorModel, StudentExamSessionEntity>>>(
          (AppErrorModel error) async {
            return Left(error);
          },
          (StudentExamSessionEntity session) async {
            final CachedExamAttemptEntity cachedAttempt = _createCachedAttempt(
              session,
            );

            final Either<AppErrorModel, Unit> cacheResult =
                await _cacheRepository.saveAttempt(attempt: cachedAttempt);

            return cacheResult.fold(
              (AppErrorModel error) {
                return Left(error);
              },
              (Unit _) {
                return Right(session);
              },
            );
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
