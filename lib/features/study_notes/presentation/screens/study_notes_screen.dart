import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotesScreen extends StatelessWidget {
  const StudyNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudyNotesCubit>()..initialize(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: const Scaffold(body: StudyNotesScreenContent()),
      ),
    );
  }
}
