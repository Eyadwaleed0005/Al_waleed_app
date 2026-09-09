import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';

abstract class StudyNotesRemoteDataSource {
  Future<List<StudyNoteModel>> getStudyNotes({
    String? gradeId,
    bool? isPublished,
  });

  Future<StudyNoteModel> getStudyNoteById({required String noteId});

  Stream<List<StudyNoteModel>> streamStudyNotes({
    String? gradeId,
    bool? isPublished,
  });
}
