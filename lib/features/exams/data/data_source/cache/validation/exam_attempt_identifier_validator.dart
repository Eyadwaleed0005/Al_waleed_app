import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';

abstract final class ExamAttemptIdentifierValidator {
  const ExamAttemptIdentifierValidator._();

  static String validate(String value) {
    final String normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      LocalStorageErrorHandler.throwInvalidData();
    }

    return normalizedValue;
  }
}
