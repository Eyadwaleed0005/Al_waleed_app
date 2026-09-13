import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';

abstract final class ExamRemoteIdentifierValidator {
  const ExamRemoteIdentifierValidator._();

  static String validate(String value) {
    final String normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    return normalizedValue;
  }
}
