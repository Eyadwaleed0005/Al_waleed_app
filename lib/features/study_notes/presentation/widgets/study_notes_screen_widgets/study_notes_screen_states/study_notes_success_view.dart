import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_list_view.dart';
import 'package:flutter/material.dart';

class StudyNotesSuccessView extends StatelessWidget {
  final List<StudyNoteEntity> notes;
  final ValueChanged<StudyNoteEntity> onNoteTap;

  const StudyNotesSuccessView({
    super.key,
    required this.notes,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return StudyNotesListView(notes: notes, onNoteTap: onNoteTap);
  }
}
