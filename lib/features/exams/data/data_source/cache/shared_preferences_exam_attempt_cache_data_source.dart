import 'dart:convert';
import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/cache/shared_preferences/shared_preference_keys.dart';
import 'package:al_waleed/core/cache/shared_preferences/shared_preferences.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/exam_attempt_cache_data_source.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/mappers/cached_exam_attempt_mapper.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/cached_exam_attempt_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_answer_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_identifier_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';

class SharedPreferencesExamAttemptCacheDataSource
    implements ExamAttemptCacheDataSource {
  Future<void> _writeQueue = Future<void>.value();

  @override
  Future<CachedExamAttemptEntity?> getAttempt({
    required String resultId,
  }) async {
    final String normalizedResultId = ExamAttemptIdentifierValidator.validate(
      resultId,
    );

    final String? encodedAttempt = await SharedPreferencesHelper.getString(
      key: SharedPreferenceKeys.examAttempt(normalizedResultId),
    );

    if (encodedAttempt == null || encodedAttempt.trim().isEmpty) {
      return null;
    }

    return CachedExamAttemptMapper.decode(encodedAttempt);
  }

  @override
  Future<List<CachedExamAttemptEntity>> getAllAttempts() async {
    final List<String> resultIds = await _getAttemptIds();

    final List<CachedExamAttemptEntity> attempts = <CachedExamAttemptEntity>[];

    for (final String resultId in resultIds) {
      final CachedExamAttemptEntity? attempt = await getAttempt(
        resultId: resultId,
      );

      if (attempt != null) {
        attempts.add(attempt);
      }
    }

    attempts.sort((first, second) {
      return first.updatedAt.compareTo(second.updatedAt);
    });

    return List<CachedExamAttemptEntity>.unmodifiable(attempts);
  }

  @override
  Future<List<CachedExamAttemptEntity>> getPendingSubmissions() async {
    final List<CachedExamAttemptEntity> attempts = await getAllAttempts();

    final List<CachedExamAttemptEntity> pendingAttempts = attempts
        .where((CachedExamAttemptEntity attempt) {
          return attempt.isPendingSubmission;
        })
        .toList(growable: false);

    return List<CachedExamAttemptEntity>.unmodifiable(pendingAttempts);
  }

  @override
  Future<void> saveAttempt({required CachedExamAttemptEntity attempt}) {
    return _enqueueWrite(() async {
      CachedExamAttemptValidator.validate(attempt);

      final String normalizedResultId = ExamAttemptIdentifierValidator.validate(
        attempt.resultId,
      );

      await SharedPreferencesHelper.saveString(
        key: SharedPreferenceKeys.examAttempt(normalizedResultId),
        value: CachedExamAttemptMapper.encode(attempt),
      );

      final List<String> resultIds = await _getAttemptIds();

      if (!resultIds.contains(normalizedResultId)) {
        resultIds.add(normalizedResultId);

        await _saveAttemptIds(resultIds);
      }
    });
  }

  @override
  Future<void> saveAnswer({
    required String resultId,
    required String questionId,
    required int? selectedChoiceIndex,
  }) {
    return _enqueueWrite(() async {
      final String normalizedResultId = ExamAttemptIdentifierValidator.validate(
        resultId,
      );

      final String normalizedQuestionId =
          ExamAttemptIdentifierValidator.validate(questionId);

      final CachedExamAttemptEntity attempt = await _requireAttempt(
        normalizedResultId,
      );

      ExamAttemptAnswerValidator.validateAnswerEditing(
        attempt: attempt,
        questionId: normalizedQuestionId,
        selectedChoiceIndex: selectedChoiceIndex,
      );

      final Map<String, int> updatedAnswers = Map<String, int>.from(
        attempt.selectedChoiceIndexes,
      );

      if (selectedChoiceIndex == null) {
        updatedAnswers.remove(normalizedQuestionId);
      } else {
        updatedAnswers[normalizedQuestionId] = selectedChoiceIndex;
      }

      final CachedExamAttemptEntity updatedAttempt = attempt.copyWith(
        selectedChoiceIndexes: Map<String, int>.unmodifiable(updatedAnswers),
        updatedAt: DateTime.now().toUtc(),
      );

      CachedExamAttemptValidator.validate(updatedAttempt);

      await SharedPreferencesHelper.saveString(
        key: SharedPreferenceKeys.examAttempt(normalizedResultId),
        value: CachedExamAttemptMapper.encode(updatedAttempt),
      );
    });
  }

  @override
  Future<void> markPendingSubmission({
    required String resultId,
    required bool isTimeExpired,
  }) {
    return _enqueueWrite(() async {
      final String normalizedResultId = ExamAttemptIdentifierValidator.validate(
        resultId,
      );

      final CachedExamAttemptEntity attempt = await _requireAttempt(
        normalizedResultId,
      );

      final CachedExamAttemptEntity updatedAttempt = attempt.copyWith(
        isTimeExpired: isTimeExpired || attempt.isTimeExpired,
        isPendingSubmission: true,
        updatedAt: DateTime.now().toUtc(),
      );

      CachedExamAttemptValidator.validate(updatedAttempt);

      await SharedPreferencesHelper.saveString(
        key: SharedPreferenceKeys.examAttempt(normalizedResultId),
        value: CachedExamAttemptMapper.encode(updatedAttempt),
      );
    });
  }

  @override
  Future<void> clearAttempt({required String resultId}) {
    return _enqueueWrite(() async {
      final String normalizedResultId = ExamAttemptIdentifierValidator.validate(
        resultId,
      );

      await SharedPreferencesHelper.removeData(
        key: SharedPreferenceKeys.examAttempt(normalizedResultId),
      );

      final List<String> resultIds = await _getAttemptIds();

      resultIds.removeWhere((String id) {
        return id == normalizedResultId;
      });

      await _saveAttemptIds(resultIds);
    });
  }

  Future<CachedExamAttemptEntity> _requireAttempt(String resultId) async {
    final CachedExamAttemptEntity? attempt = await getAttempt(
      resultId: resultId,
    );

    if (attempt == null) {
      LocalStorageErrorHandler.throwDataNotFound();
    }

    return attempt;
  }

  Future<List<String>> _getAttemptIds() async {
    final String? encodedIds = await SharedPreferencesHelper.getString(
      key: SharedPreferenceKeys.examAttemptIds,
    );

    if (encodedIds == null || encodedIds.trim().isEmpty) {
      return <String>[];
    }

    final dynamic decoded;

    try {
      decoded = jsonDecode(encodedIds);
    } on FormatException {
      LocalStorageErrorHandler.throwInvalidData();
    }

    if (decoded is! List) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    final List<String> resultIds = decoded
        .map((dynamic value) {
          return ExamAttemptIdentifierValidator.validate(
            value?.toString() ?? '',
          );
        })
        .toSet()
        .toList(growable: true);

    return resultIds;
  }

  Future<void> _saveAttemptIds(List<String> resultIds) async {
    final List<String> normalizedResultIds = resultIds
        .map(ExamAttemptIdentifierValidator.validate)
        .toSet()
        .toList(growable: false);

    if (normalizedResultIds.isEmpty) {
      await SharedPreferencesHelper.removeData(
        key: SharedPreferenceKeys.examAttemptIds,
      );

      return;
    }

    await SharedPreferencesHelper.saveString(
      key: SharedPreferenceKeys.examAttemptIds,
      value: jsonEncode(normalizedResultIds),
    );
  }

  Future<T> _enqueueWrite<T>(Future<T> Function() operation) {
    final Future<T> queuedOperation = _writeQueue.then((_) {
      return operation();
    });

    _writeQueue = queuedOperation.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );

    return queuedOperation;
  }
}
