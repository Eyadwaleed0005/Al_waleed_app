import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStudyNotesRemoteDataSource implements StudyNotesRemoteDataSource {
  const FirebaseStudyNotesRemoteDataSource({required this._firestoreService});

  final FirestoreService _firestoreService;

  @override
  Future<StudyNoteModel> getStudyNoteById({
    required String noteId,
    required String gradeId,
  }) {
    return FirebaseErrorHandler.execute(() async {
      return _getRequiredStudyNote(noteId: noteId, gradeId: gradeId);
    });
  }

  @override
  Stream<List<StudyNoteModel>> streamStudyNotes({required String gradeId}) {
    return FirebaseErrorHandler.executeStream(() {
      final normalizedGradeId = _normalizeRequiredValue(value: gradeId);

      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.studyNotes,
            queryBuilder: _getNotesQuery(gradeId: normalizedGradeId),
          )
          .map(_mapStudyNotes);
    });
  }

  Future<StudyNoteModel> _getRequiredStudyNote({
    required String noteId,
    required String gradeId,
  }) async {
    final normalizedNoteId = _normalizeRequiredValue(value: noteId);

    final normalizedGradeId = _normalizeRequiredValue(value: gradeId);

    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.studyNotes,
      documentId: normalizedNoteId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    final noteGradeId = data[FirestoreFields.gradeId];
    final isPublished = data[FirestoreFields.isPublished];

    final belongsToStudentGrade =
        noteGradeId is String && noteGradeId.trim() == normalizedGradeId;

    final isAvailableToStudents = isPublished == true;

    if (!belongsToStudentGrade || !isAvailableToStudents) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return StudyNoteModel.fromMap(documentId: snapshot.id, map: data);
  }

  FirestoreQueryBuilder _getNotesQuery({required String gradeId}) {
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

  List<StudyNoteModel> _mapStudyNotes(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final notes = snapshot.docs.map((document) {
      return StudyNoteModel.fromMap(
        documentId: document.id,
        map: document.data(),
      );
    }).toList();

    notes.sort((firstNote, secondNote) {
      final firstCreatedAt = firstNote.createdAt;
      final secondCreatedAt = secondNote.createdAt;

      if (firstCreatedAt == null && secondCreatedAt == null) {
        return firstNote.name.compareTo(secondNote.name);
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

      return firstNote.name.compareTo(secondNote.name);
    });

    return List<StudyNoteModel>.unmodifiable(notes);
  }
}
