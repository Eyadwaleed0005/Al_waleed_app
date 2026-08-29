import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';

abstract class StudyNotesDataSource {
  Future<List<StudyNoteModel>> getStudyNotes();
}
