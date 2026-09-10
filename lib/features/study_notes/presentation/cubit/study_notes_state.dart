import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';

sealed class StudyNotesState {
  const StudyNotesState();
}

final class StudyNotesInitial extends StudyNotesState {
  const StudyNotesInitial();
}

final class StudyNotesLoading extends StudyNotesState {
  const StudyNotesLoading();
}

final class StudyNotesFailure extends StudyNotesState {
  const StudyNotesFailure({required this.error});

  final AppErrorModel error;
}

final class StudyNotesDataSuccess extends StudyNotesState {
  const StudyNotesDataSuccess({required this.notes});

  final List<StudyNoteEntity> notes;
}
