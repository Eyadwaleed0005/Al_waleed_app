import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_pdf_reader_screen_widgets/study_note_pdf_reader_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudyNotePdfReaderScreen extends StatelessWidget {
  const StudyNotePdfReaderScreen({super.key, required this.note});

  final StudyNoteEntity note;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: StudyNotePdfReaderContent(note: note),
    );
  }
}
