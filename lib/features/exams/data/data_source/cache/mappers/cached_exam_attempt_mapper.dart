import 'dart:convert';

import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/mappers/exam_attempt_cache_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/cached_exam_attempt_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_answer_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_identifier_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';

abstract final class CachedExamAttemptMapper {
  const CachedExamAttemptMapper._();

  static String encode(CachedExamAttemptEntity attempt) {
    return jsonEncode(toMap(attempt));
  }

  static CachedExamAttemptEntity decode(String encodedAttempt) {
    final dynamic decoded;

    try {
      decoded = jsonDecode(encodedAttempt);
    } on FormatException {
      LocalStorageErrorHandler.throwInvalidData();
    }

    if (decoded is! Map) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final Map<String, dynamic> data = decoded.map<String, dynamic>((
      dynamic key,
      dynamic value,
    ) {
      return MapEntry(key.toString(), value);
    });

    return fromMap(data);
  }

  static Map<String, dynamic> toMap(CachedExamAttemptEntity attempt) {
    CachedExamAttemptValidator.validate(attempt);

    final Map<String, int> normalizedAnswers = <String, int>{};

    for (final MapEntry<String, int> answer
        in attempt.selectedChoiceIndexes.entries) {
      final String questionId = ExamAttemptIdentifierValidator.validate(
        answer.key,
      );

      ExamAttemptAnswerValidator.validateRequiredChoiceIndex(answer.value);

      if (normalizedAnswers.containsKey(questionId)) {
        LocalStorageErrorHandler.throwInvalidData();
      }

      normalizedAnswers[questionId] = answer.value;
    }

    return <String, dynamic>{
      ExamAttemptCacheFields.resultId: ExamAttemptIdentifierValidator.validate(
        attempt.resultId,
      ),
      ExamAttemptCacheFields.examId: ExamAttemptIdentifierValidator.validate(
        attempt.examId,
      ),
      ExamAttemptCacheFields.questionIds: attempt.questionIds
          .map(ExamAttemptIdentifierValidator.validate)
          .toList(growable: false),
      ExamAttemptCacheFields.selectedChoiceIndexes: normalizedAnswers,
      ExamAttemptCacheFields.startedAt: attempt.startedAt
          .toUtc()
          .toIso8601String(),
      ExamAttemptCacheFields.expiresAt: attempt.expiresAt
          .toUtc()
          .toIso8601String(),
      ExamAttemptCacheFields.isTimeExpired: attempt.isTimeExpired,
      ExamAttemptCacheFields.isPendingSubmission: attempt.isPendingSubmission,
      ExamAttemptCacheFields.updatedAt: attempt.updatedAt
          .toUtc()
          .toIso8601String(),
    };
  }

  static CachedExamAttemptEntity fromMap(Map<String, dynamic> data) {
    final CachedExamAttemptEntity attempt = CachedExamAttemptEntity(
      resultId: ExamAttemptIdentifierValidator.validate(
        _readString(data[ExamAttemptCacheFields.resultId]),
      ),
      examId: ExamAttemptIdentifierValidator.validate(
        _readString(data[ExamAttemptCacheFields.examId]),
      ),
      questionIds: List<String>.unmodifiable(
        _readQuestionIds(data[ExamAttemptCacheFields.questionIds]),
      ),
      selectedChoiceIndexes: Map<String, int>.unmodifiable(
        _readSelectedChoiceIndexes(
          data[ExamAttemptCacheFields.selectedChoiceIndexes],
        ),
      ),
      startedAt: _readDateTime(data[ExamAttemptCacheFields.startedAt]),
      expiresAt: _readDateTime(data[ExamAttemptCacheFields.expiresAt]),
      isTimeExpired: _readBool(data[ExamAttemptCacheFields.isTimeExpired]),
      isPendingSubmission: _readBool(
        data[ExamAttemptCacheFields.isPendingSubmission],
      ),
      updatedAt: _readDateTime(data[ExamAttemptCacheFields.updatedAt]),
    );

    CachedExamAttemptValidator.validate(attempt);

    return attempt;
  }

  static List<String> _readQuestionIds(dynamic value) {
    if (value is! List) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final List<String> questionIds = value
        .map((dynamic questionId) {
          return ExamAttemptIdentifierValidator.validate(
            _readString(questionId),
          );
        })
        .toList(growable: false);

    if (questionIds.isEmpty ||
        questionIds.length != questionIds.toSet().length) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    return questionIds;
  }

  static Map<String, int> _readSelectedChoiceIndexes(dynamic value) {
    if (value == null) {
      return <String, int>{};
    }

    if (value is! Map) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final Map<String, int> selectedChoiceIndexes = <String, int>{};

    value.forEach((dynamic key, dynamic rawChoiceIndex) {
      final String questionId = ExamAttemptIdentifierValidator.validate(
        _readString(key),
      );

      if (selectedChoiceIndexes.containsKey(questionId)) {
        LocalStorageErrorHandler.throwInvalidData();
      }

      final int selectedChoiceIndex = _readInt(rawChoiceIndex);

      ExamAttemptAnswerValidator.validateRequiredChoiceIndex(
        selectedChoiceIndex,
      );

      selectedChoiceIndexes[questionId] = selectedChoiceIndex;
    });

    return selectedChoiceIndexes;
  }

  static String _readString(dynamic value) {
    if (value is! String) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    return value;
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      if (!value.isFinite || value != value.toInt()) {
        LocalStorageErrorHandler.throwInvalidData();
      }

      return value.toInt();
    }

    LocalStorageErrorHandler.throwInvalidData();
  }

  static bool _readBool(dynamic value) {
    if (value is! bool) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    return value;
  }

  static DateTime _readDateTime(dynamic value) {
    if (value is! String) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final DateTime? dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    return dateTime.toUtc();
  }
}
