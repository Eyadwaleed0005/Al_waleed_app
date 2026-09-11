import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';

abstract class StudyNotesRemoteDataSource {
  Future<StudyNoteModel> getStudyNoteById({
    required String noteId,
    required String gradeId,
  });

  Stream<List<StudyNoteModel>> streamStudyNotes({required String gradeId});
}
