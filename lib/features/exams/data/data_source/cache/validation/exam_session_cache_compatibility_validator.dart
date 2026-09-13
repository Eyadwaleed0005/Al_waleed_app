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
    if (cachedAttempt.resultId.trim() != session.attempt.resultId.trim() ||
        cachedAttempt.examId.trim() != session.exam.examId.trim() ||
        cachedAttempt.examId.trim() != session.attempt.examId.trim()) {
      return _invalidCache();
    }

    if (!cachedAttempt.startedAt.toUtc().isAtSameMomentAs(
          session.attempt.startedAt.toUtc(),
        ) ||
        !cachedAttempt.expiresAt.toUtc().isAtSameMomentAs(
          session.attempt.expiresAt.toUtc(),
        )) {
      return _invalidCache();
    }

    final Set<String> cachedQuestionIds = cachedAttempt.questionIds
        .map((String questionId) => questionId.trim())
        .toSet();

    final Set<String> sessionQuestionIds = session.questions
        .map((question) => question.questionId.trim())
        .toSet();

    if (cachedQuestionIds.length != sessionQuestionIds.length ||
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
