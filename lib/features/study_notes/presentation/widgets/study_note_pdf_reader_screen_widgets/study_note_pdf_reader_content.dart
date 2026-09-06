import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudyNotePdfReaderContent extends StatelessWidget {
  const StudyNotePdfReaderContent({super.key});

  static const String _testPdfUrl =
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المذكرة',
        titleColor: ColorPalette.cardBackground,
        backButtonColor: ColorPalette.cardBackground,
        backgroundColor: ColorPalette.primary,
        showBackButton: true,
        actions: [
          SizedBox(
            width: 56.w,
            child: Center(
              child: ImageIcon(
                AssetImage(AppImage().studyNotes),
                size: 26.r,
                color: ColorPalette.cardBackground,
              ),
            ),
          ),
        ],
      ),
      body: BackgroundStudentLayout(
        child: SfPdfViewer.network(
          _testPdfUrl,
          enableDoubleTapZooming: true,
          canShowScrollHead: true,
          canShowPaginationDialog: true,
        ),
      ),
    );
  }
}
