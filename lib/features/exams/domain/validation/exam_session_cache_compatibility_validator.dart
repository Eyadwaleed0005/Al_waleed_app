import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:dartz/dartz.dart';

abstract final class ExamSessionCacheCompatibilityValidator {
  const ExamSessionCacheCompatibilityValidator._();

  static Either<AppErrorModel, Unit> validate({
    required StudentExamSessionEntity session,
    required CachedExamAttemptEntity cachedAttempt,
  }) {
    final String cachedResultId = cachedAttempt.resultId.trim();
    final String sessionResultId = session.attempt.resultId.trim();

    final String cachedExamId = cachedAttempt.examId.trim();
    final String sessionExamId = session.exam.examId.trim();
    final String attemptExamId = session.attempt.examId.trim();

    if (cachedResultId != sessionResultId ||
        cachedExamId != sessionExamId ||
        cachedExamId != attemptExamId) {
      return _invalidCache();
    }

    final DateTime cachedStartedAt = cachedAttempt.startedAt.toUtc();
    final DateTime sessionStartedAt = session.attempt.startedAt.toUtc();

    final DateTime cachedExpiresAt = cachedAttempt.expiresAt.toUtc();
    final DateTime sessionExpiresAt = session.attempt.expiresAt.toUtc();

    if (!cachedStartedAt.isAtSameMomentAs(sessionStartedAt) ||
        !cachedExpiresAt.isAtSameMomentAs(sessionExpiresAt)) {
      return _invalidCache();
    }

    final Set<String> cachedQuestionIds = cachedAttempt.questionIds
        .map((String questionId) => questionId.trim())
        .toSet();

    final Set<String> sessionQuestionIds = session.questions
        .map((question) => question.questionId.trim())
        .toSet();

    if (cachedQuestionIds.length != cachedAttempt.questionIds.length ||
        sessionQuestionIds.length != session.questions.length ||
        cachedQuestionIds.length != sessionQuestionIds.length ||
        !cachedQuestionIds.containsAll(sessionQuestionIds)) {
      return _invalidCache();
    }

    return const Right(unit);
  }

  static Either<AppErrorModel, Unit> _invalidCache() {
    return Left(
      LocalStorageErrorHandler.handleCode(LocalStorageErrorCodes.invalidData),
    );
  }
}
