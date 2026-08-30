import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_document_preview.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_page_progress.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_Reader_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonPdfReaderContentScreen extends StatelessWidget {
  const LessonPdfReaderContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              titleWidget: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  text: 'ملف الدرس\n',
                  style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                  children: [
                    TextSpan(
                      text: 'الكيمياء العضوية',
                      style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                    ),
                  ],
                ),
              ),
              showBackButton: true,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Image.asset(
                    AppImage().readerPdf,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const LessonPageProgress(),
            ),
            verticalSpace(18),
            const Expanded(child: LessonDocumentPreview()),
            verticalSpace(16),
            const LessonReaderControls(),
            verticalSpace(16),
          ],
        ),
      ),
    );
  }
}
