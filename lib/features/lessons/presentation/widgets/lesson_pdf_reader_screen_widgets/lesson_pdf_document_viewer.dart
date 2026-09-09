import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LessonPdfDocumentViewer extends StatelessWidget {
  const LessonPdfDocumentViewer({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(
      pdfUrl,
      enableDoubleTapZooming: true,
      canShowScrollHead: true,
      canShowPaginationDialog: true,
    );
  }
}
