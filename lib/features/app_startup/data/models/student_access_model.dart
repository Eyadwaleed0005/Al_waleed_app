import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/app_startup/domain/entities/student_access_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAccessModel extends StudentAccessEntity {
  const StudentAccessModel({
    required super.studentId,
    required super.gradeId,
    required super.isActive,
    required super.subscriptionEndAt,
  });

  factory StudentAccessModel.fromFirestore({
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    return StudentAccessModel(
      studentId: _readRequiredDocumentId(documentId),
      gradeId: _readRequiredString(data: data, field: FirestoreFields.gradeId),
      isActive: _readRequiredBool(data: data, field: FirestoreFields.isActive),
      subscriptionEndAt: _readRequiredDateTime(
        data: data,
        field: FirestoreFields.subscriptionEndAt,
      ),
    );
  }

  StudentAccessEntity toEntity() {
    return StudentAccessEntity(
      studentId: studentId,
      gradeId: gradeId,
      isActive: isActive,
      subscriptionEndAt: subscriptionEndAt,
    );
  }

  static String _readRequiredDocumentId(String documentId) {
    final normalizedDocumentId = documentId.trim();

    if (normalizedDocumentId.isEmpty) {
      throw const FormatException('Student document ID is missing.');
    }

    return normalizedDocumentId;
  }

  static String _readRequiredString({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Missing or invalid field: $field');
    }

    return value.trim();
  }

  static bool _readRequiredBool({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! bool) {
      throw FormatException('Missing or invalid field: $field');
    }

    return value;
  }

  static DateTime _readRequiredDateTime({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is Timestamp) {
      return value.toDate().toUtc();
    }

    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    }

    if (value is String) {
      final parsedDate = DateTime.tryParse(value);

      if (parsedDate != null) {
        return parsedDate.toUtc();
      }
    }

    throw FormatException('Missing or invalid field: $field');
  }
}
