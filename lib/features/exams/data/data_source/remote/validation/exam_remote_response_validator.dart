import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class ExamRemoteResponseValidator {
  const ExamRemoteResponseValidator._();

  static Map<String, dynamic> readMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map<String, dynamic>((dynamic key, dynamic item) {
        return MapEntry(key.toString(), item);
      });
    }

    FirebaseErrorHandler.throwFirestoreCode('data-loss');
  }

  static List<dynamic> readList(dynamic value) {
    if (value is List) {
      return value;
    }

    FirebaseErrorHandler.throwFirestoreCode('data-loss');
  }

  static String readRequiredString(dynamic value) {
    final String normalizedValue = value?.toString().trim() ?? '';

    if (normalizedValue.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    return normalizedValue;
  }

  static String? readNullableString(dynamic value) {
    final String normalizedValue = value?.toString().trim() ?? '';

    if (normalizedValue.isEmpty) {
      return null;
    }

    return normalizedValue;
  }

  static int readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      if (!value.isFinite || value != value.toInt()) {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }

      return value.toInt();
    }

    final int? parsedValue = int.tryParse(value?.toString() ?? '');

    if (parsedValue == null) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    return parsedValue;
  }

  static int? readNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    return readInt(value);
  }

  static DateTime readRequiredDateTime(dynamic value) {
    final DateTime? dateTime = readDateTime(value);

    if (dateTime == null) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    return dateTime;
  }

  static DateTime? readDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate().toUtc();
    }

    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is String) {
      return DateTime.tryParse(value)?.toUtc();
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    }

    if (value is Map) {
      final Map<String, dynamic> timestampData = readMap(value);

      final dynamic secondsValue =
          timestampData['_seconds'] ?? timestampData['seconds'];

      final dynamic nanosecondsValue =
          timestampData['_nanoseconds'] ?? timestampData['nanoseconds'] ?? 0;

      if (secondsValue is num && nanosecondsValue is num) {
        final int microseconds =
            (secondsValue.toInt() * Duration.microsecondsPerSecond) +
            (nanosecondsValue.toInt() ~/ 1000);

        return DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);
      }
    }

    return null;
  }

  static void ensureQuestionIsSafe(Map<String, dynamic> questionData) {
    if (questionData.containsKey(FirestoreFields.correctOption)) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }

  static void ensurePositive(int value) {
    if (value <= 0) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }

  static void ensureNotNegative(int value) {
    if (value < 0) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }
}
