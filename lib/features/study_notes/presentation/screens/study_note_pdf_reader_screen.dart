import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_note_pdf_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_pdf_reader_screen_widgets/study_note_pdf_reader_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotePdfReaderScreen extends StatelessWidget {
  final StudyNoteEntity note;

  const StudyNotePdfReaderScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudyNotePdfCubit>()..loadPdf(note: note),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: StudyNotePdfReaderContent(note: note),
      ),
    );
  }
}
