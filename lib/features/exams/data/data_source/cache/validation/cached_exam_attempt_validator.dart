import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_answer_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_identifier_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';

abstract final class CachedExamAttemptValidator {
  const CachedExamAttemptValidator._();

  static void validate(CachedExamAttemptEntity attempt) {
    ExamAttemptIdentifierValidator.validate(attempt.resultId);

    ExamAttemptIdentifierValidator.validate(attempt.examId);

    if (attempt.questionIds.isEmpty) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final Set<String> normalizedQuestionIds = attempt.questionIds.map((
      String questionId,
    ) {
      return ExamAttemptIdentifierValidator.validate(questionId);
    }).toSet();

    if (normalizedQuestionIds.length != attempt.questionIds.length) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final Set<String> answeredQuestionIds = <String>{};

    for (final MapEntry<String, int> answer
        in attempt.selectedChoiceIndexes.entries) {
      final String normalizedQuestionId =
          ExamAttemptIdentifierValidator.validate(answer.key);

      if (!normalizedQuestionIds.contains(normalizedQuestionId)) {
        LocalStorageErrorHandler.throwInvalidData();
      }

      if (!answeredQuestionIds.add(normalizedQuestionId)) {
        LocalStorageErrorHandler.throwInvalidData();
      }

      ExamAttemptAnswerValidator.validateRequiredChoiceIndex(answer.value);
    }

    final DateTime startedAt = attempt.startedAt.toUtc();
    final DateTime expiresAt = attempt.expiresAt.toUtc();

    if (!expiresAt.isAfter(startedAt)) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    if (attempt.isTimeExpired && !attempt.isPendingSubmission) {
      LocalStorageErrorHandler.throwInvalidData();
    }
  }
}
