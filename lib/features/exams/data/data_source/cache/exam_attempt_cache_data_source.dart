import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';

abstract interface class ExamAttemptCacheDataSource {
  Future<CachedExamAttemptEntity?> getAttempt({required String resultId});

  Future<List<CachedExamAttemptEntity>> getAllAttempts();

  Future<List<CachedExamAttemptEntity>> getPendingSubmissions();

  Future<void> saveAttempt({required CachedExamAttemptEntity attempt});

  Future<void> saveAnswer({
    required String resultId,
    required String questionId,
    required int? selectedChoiceIndex,
  });

  Future<void> markPendingSubmission({
    required String resultId,
    required bool isTimeExpired,
  });

  Future<void> clearAttempt({required String resultId});
}
