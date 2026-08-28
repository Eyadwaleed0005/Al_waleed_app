import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_data_source.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';

class StudyNotesRepositoryImpl implements StudyNotesRepository {
  const StudyNotesRepositoryImpl(this._dataSource);

  final StudyNotesDataSource _dataSource;

  @override
  Future<List<StudyNoteEntity>> getStudyNotes() async {
    return await _dataSource.getStudyNotes();
  }
}
