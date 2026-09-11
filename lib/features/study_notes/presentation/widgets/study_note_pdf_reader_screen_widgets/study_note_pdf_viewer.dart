import 'dart:typed_data';

import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudyNotePdfViewer extends StatelessWidget {
  final Uint8List pdfBytes;

  const StudyNotePdfViewer({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    final pageInfoTextStyle = AppTextStyle.font12TextSecondaryMediumTajawal()
        .copyWith(color: ColorPalette.cardBackground);

    return SfPdfViewerTheme(
      data: SfPdfViewerThemeData(
        backgroundColor: Colors.transparent,
        progressBarColor: ColorPalette.primary,
        scrollHeadStyle: PdfScrollHeadStyle(
          backgroundColor: ColorPalette.primary,
          pageNumberTextStyle: pageInfoTextStyle,
        ),
        scrollStatusStyle: PdfScrollStatusStyle(
          backgroundColor: ColorPalette.primary,
          pageInfoTextStyle: pageInfoTextStyle,
        ),
      ),
      child: SfPdfViewer.memory(
        pdfBytes,
        enableDoubleTapZooming: true,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
      ),
    );
  }
}
