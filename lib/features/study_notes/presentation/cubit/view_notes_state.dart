import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';

abstract class ViewNotesState {
  const ViewNotesState();
}

class ViewNotesInitial extends ViewNotesState {
  const ViewNotesInitial();
}

class ViewNotesLoading extends ViewNotesState {
  const ViewNotesLoading();
}

class ViewNotesLoaded extends ViewNotesState {
  const ViewNotesLoaded(this.notes);

  final List<StudyNoteEntity> notes;
}

class ViewNotesFailure extends ViewNotesState {
  const ViewNotesFailure(this.message);

  final String message;
}
