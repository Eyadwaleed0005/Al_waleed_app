import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStudyNotesRemoteDataSource implements StudyNotesRemoteDataSource {
  const FirebaseStudyNotesRemoteDataSource({required this._firestoreService});

  final FirestoreService _firestoreService;

  @override
  Future<List<StudyNoteModel>> getStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final snapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.studyNotes,
        queryBuilder: _getNotesQuery(
          gradeId: gradeId,
          isPublished: isPublished,
        ),
      );

      return _mapStudyNotes(snapshot);
    });
  }

  @override
  Future<StudyNoteModel> getStudyNoteById({required String noteId}) {
    return FirebaseErrorHandler.execute(() async {
      return _getRequiredStudyNote(noteId: noteId);
    });
  }

  @override
  Stream<List<StudyNoteModel>> streamStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) {
    return FirebaseErrorHandler.executeStream(() {
      return _firestoreService
          .streamCollection(
            collectionPath: FirestoreCollections.studyNotes,
            queryBuilder: _getNotesQuery(
              gradeId: gradeId,
              isPublished: isPublished,
            ),
          )
          .map(_mapStudyNotes);
    });
  }

  Future<StudyNoteModel> _getRequiredStudyNote({required String noteId}) async {
    final normalizedNoteId = noteId.trim();

    final snapshot = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.studyNotes,
      documentId: normalizedNoteId,
    );

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return StudyNoteModel.fromMap(documentId: snapshot.id, map: data);
  }

  FirestoreQueryBuilder? _getNotesQuery({String? gradeId, bool? isPublished}) {
    final normalizedGradeId = gradeId?.trim();

    final hasGradeFilter =
        normalizedGradeId != null && normalizedGradeId.isNotEmpty;

    final hasPublicationFilter = isPublished != null;

    if (!hasGradeFilter && !hasPublicationFilter) {
      return null;
    }

    return (collection) {
      Query<Map<String, dynamic>> query = collection;

      if (hasGradeFilter) {
        query = query.where(
          FirestoreFields.gradeId,
          isEqualTo: normalizedGradeId,
        );
      }

      if (hasPublicationFilter) {
        query = query.where(
          FirestoreFields.isPublished,
          isEqualTo: isPublished,
        );
      }

      return query;
    };
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
