import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';

class GetStudyNotesUseCase {
  const GetStudyNotesUseCase(this._repository);

  final StudyNotesRepository _repository;

  Future<List<StudyNoteEntity>> call() async {
    return await _repository.getStudyNotes();
  }
}
