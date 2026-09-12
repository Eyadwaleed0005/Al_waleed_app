import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/lessons_remote_data_source.dart';
import 'package:al_waleed/features/lessons/data/models/lesson_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLessonsRemoteDataSource implements LessonsRemoteDataSource {
  const FirebaseLessonsRemoteDataSource({required this._firestoreService});

  final FirestoreService _firestoreService;

  @override
  Future<LessonModel> getLessonById({
    required String lessonId,
    required String gradeId,
  }) {
    return FirebaseErrorHandler.execute(() async {
      return _getRequiredLesson(lessonId: lessonId, gradeId: gradeId);
    });
  }

  @override
  Stream<List<LessonModel>> streamLessons({required String gradeId}) {
    return FirebaseErrorHandler.executeStream(() {
      final normalizedGradeId = _normalizeRequiredValue(value: gradeId);

      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.lessons,
            queryBuilder: _getLessonsQuery(gradeId: normalizedGradeId),
          )
          .map(_mapLessons);
    });
  }

  Future<LessonModel> _getRequiredLesson({
    required String lessonId,
    required String gradeId,
  }) async {
    final normalizedLessonId = _normalizeRequiredValue(value: lessonId);

    final normalizedGradeId = _normalizeRequiredValue(value: gradeId);

    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.lessons,
      documentId: normalizedLessonId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    final lessonGradeId = data[FirestoreFields.gradeId];
    final isPublished = data[FirestoreFields.isPublished];

    final belongsToStudentGrade =
        lessonGradeId is String && lessonGradeId.trim() == normalizedGradeId;

    final isAvailableToStudents = isPublished == true;

    if (!belongsToStudentGrade || !isAvailableToStudents) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return LessonModel.fromMap(documentId: snapshot.id, map: data);
  }

  FirestoreQueryBuilder _getLessonsQuery({required String gradeId}) {
    return (collection) {
      Query<Map<String, dynamic>> query = collection;

      query = query.where(FirestoreFields.gradeId, isEqualTo: gradeId);

      query = query.where(FirestoreFields.isPublished, isEqualTo: true);

      return query;
    };
  }

  String _normalizeRequiredValue({required String value}) {
    final normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    return normalizedValue;
  }

  List<LessonModel> _mapLessons(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final lessons = snapshot.docs.map((document) {
      return LessonModel.fromMap(
        documentId: document.id,
        map: document.data(),
      );
    }).toList();

    lessons.sort((firstLesson, secondLesson) {
      final firstCreatedAt = firstLesson.createdAt;
      final secondCreatedAt = secondLesson.createdAt;

      if (firstCreatedAt == null && secondCreatedAt == null) {
        return firstLesson.title.compareTo(secondLesson.title);
      }

      if (firstCreatedAt == null) {
        return 1;
      }

      if (secondCreatedAt == null) {
        return -1;
      }

      final dateComparison = secondCreatedAt.compareTo(firstCreatedAt);

      if (dateComparison != 0) {
        return dateComparison;
      }

      return firstLesson.title.compareTo(secondLesson.title);
    });

    return List<LessonModel>.unmodifiable(lessons);
  }
}