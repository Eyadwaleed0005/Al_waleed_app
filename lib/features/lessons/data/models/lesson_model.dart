import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.lessonId,
    required super.title,
    required super.description,
    required super.gradeId,
    required super.isPublished,
    required super.youtubeUrl,
    required super.pdfStoragePath,
    required super.pdfFileName,
    required super.pdfFileSize,
    super.createdAt,
    super.updatedAt,
  });

  factory LessonModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    return LessonModel(
      lessonId: documentId,
      title: map[FirestoreFields.title] as String? ?? '',
      description: map[FirestoreFields.description] as String? ?? '',
      gradeId: map[FirestoreFields.gradeId] as String? ?? '',
      isPublished: map[FirestoreFields.isPublished] as bool? ?? false,
      youtubeUrl: map[FirestoreFields.youtubeUrl] as String? ?? '',
      pdfStoragePath: map[FirestoreFields.pdfStoragePath] as String? ?? '',
      pdfFileName: map[FirestoreFields.pdfFileName] as String? ?? '',
      pdfFileSize: _readFileSize(map[FirestoreFields.pdfFileSize]),
      createdAt: _readDateTime(map[FirestoreFields.createdAt]),
      updatedAt: _readDateTime(map[FirestoreFields.updatedAt]),
    );
  }

  static int _readFileSize(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  static DateTime? _readDateTime(Object? value) {
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
      return DateTime.tryParse(value)?.toUtc();
    }

    return null;
  }
}