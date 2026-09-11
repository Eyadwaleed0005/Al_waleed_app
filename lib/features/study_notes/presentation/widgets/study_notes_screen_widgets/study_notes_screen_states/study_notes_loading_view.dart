import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_loading_skeleton.dart';
import 'package:flutter/material.dart';

class StudyNotesLoadingView extends StatelessWidget {
  const StudyNotesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudyNotesLoadingSkeleton();
  }
}