import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_pdf_reader_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudyNotePdfReaderScreen extends StatelessWidget {
  const StudyNotePdfReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: const StudyNotePdfReaderContent(),
    );
  }
}
