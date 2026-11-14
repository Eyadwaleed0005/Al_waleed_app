import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_list_view.dart';
import 'package:flutter/material.dart';

class StudyNotesSuccessView extends StatelessWidget {
  const StudyNotesSuccessView({
    super.key,
    required this.notes,
    required this.showFree,
    required this.hasValidSubscription,
    required this.onAccessTypeChanged,
    required this.onNoteTap,
  });

  final List<StudyNoteEntity> notes;
  final bool showFree;
  final bool? hasValidSubscription;
  final ValueChanged<bool> onAccessTypeChanged;
  final ValueChanged<StudyNoteEntity> onNoteTap;

  @override
  Widget build(BuildContext context) {
    return StudyNotesListView(
      notes: notes,
      showFree: showFree,
      hasValidSubscription: hasValidSubscription,
      onAccessTypeChanged: onAccessTypeChanged,
      onNoteTap: onNoteTap,
    );
  }
}
