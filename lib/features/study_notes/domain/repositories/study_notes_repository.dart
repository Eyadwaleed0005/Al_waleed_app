import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';

abstract class StudyNotesRepository {
  Future<List<StudyNoteEntity>> getStudyNotes();
}
