abstract final class SharedPreferenceKeys {
  const SharedPreferenceKeys._();
  static const String gradeId = 'grade_id';

  static const String examAttemptIds = 'exam_attempt_ids';

  static const String examAttemptPrefix = 'exam_attempt_';

  static const String hasCompletedOnboarding = 'has_completed_onboarding';

  static String examAttempt(String resultId) {
    final String normalizedResultId = resultId.trim();

    if (normalizedResultId.isEmpty) {
      throw ArgumentError.value(
        resultId,
        'resultId',
        'resultId cannot be empty.',
      );
    }

    return '$examAttemptPrefix$normalizedResultId';
  }
}
