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

final class StudyNotesEmpty extends StudyNotesState {
  const StudyNotesEmpty();
}

final class StudyNotesFailure extends StudyNotesState {
  final AppErrorModel error;

  const StudyNotesFailure({required this.error});
}

final class StudyNotesDataSuccess extends StudyNotesState {
  final List<StudyNoteEntity> notes;

  const StudyNotesDataSuccess({required this.notes});
}
