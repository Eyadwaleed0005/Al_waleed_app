import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessonPdfReaderScreen extends StatelessWidget {
  const LessonPdfReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: const LessonPdfReaderContent(),
    );
  }
}