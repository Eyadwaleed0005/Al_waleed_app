import 'dart:typed_data';

import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_document_viewer.dart';
import 'package:flutter/material.dart';

class LessonPdfSuccessView extends StatelessWidget {
  const LessonPdfSuccessView({super.key, required this.pdfBytes});

  final Uint8List pdfBytes;

  @override
  Widget build(BuildContext context) {
    return LessonPdfDocumentViewer(pdfBytes: pdfBytes);
  }
}
