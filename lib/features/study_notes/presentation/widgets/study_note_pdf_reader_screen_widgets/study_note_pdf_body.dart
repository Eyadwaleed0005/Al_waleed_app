import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudyNotePdfBody extends StatelessWidget {
  const StudyNotePdfBody({super.key, required this.note});

  final StudyNoteEntity note;

  @override
  Widget build(BuildContext context) {
    final storagePath = note.pdfStoragePath.trim();

    if (storagePath.isEmpty) {
      return const AppErrorState(
        message: 'لا يوجد ملف PDF مرفق بهذه المذكرة',
      );
    }

    final pdfUrl =
        'https://firebasestorage.googleapis.com/v0/b/'
        'alwaleed-education-platform.firebasestorage.app/o/'
        '${Uri.encodeComponent(storagePath)}?alt=media';

    return SfPdfViewer.network(
      pdfUrl,
      enableDoubleTapZooming: true,
      canShowScrollHead: true,
      canShowPaginationDialog: true,
    );
  }
}
