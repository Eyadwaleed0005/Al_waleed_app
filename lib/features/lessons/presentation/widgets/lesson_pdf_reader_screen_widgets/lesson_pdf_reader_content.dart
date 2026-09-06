import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_document_viewer.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_header.dart';
import 'package:flutter/material.dart';

class LessonPdfReaderContent extends StatelessWidget {
  const LessonPdfReaderContent({
    super.key,
    this.lessonTitle = 'الكيمياء العضوية',
    this.pdfUrl = _testPdfUrl,
  });

  final String lessonTitle;
  final String pdfUrl;

  static const String _testPdfUrl =
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LessonPdfReaderHeader(lessonTitle: lessonTitle),
      body: BackgroundStudentLayout(
        child: LessonPdfDocumentViewer(pdfUrl: pdfUrl),
      ),
    );
  }
}
