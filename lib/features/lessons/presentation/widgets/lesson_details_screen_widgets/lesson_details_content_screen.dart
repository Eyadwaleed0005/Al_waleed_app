import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_details_screen_widgets/lesson_material_tile.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_details_screen_widgets/lesson_overview_card.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_details_screen_widgets/lesson_video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonDetailsContentScreen extends StatelessWidget {
  const LessonDetailsContentScreen({super.key, required this.lesson});

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAppBar(
                title: lesson.title,
                showBackButton: true,
                backgroundColor: Colors.transparent,
              ),

              verticalSpace(15),

              if (lesson.hasYoutubeVideo) ...[
                LessonVideoCard(videoUrl: lesson.youtubeUrl),
                verticalSpace(20),
              ],

              LessonOverviewCard(description: lesson.description),

              verticalSpace(76),

              Text(
                'محتوى الدرس',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
              ),

              verticalSpace(14),

              LessonMaterialTile(
                title: 'ملف الدرس',
                subtitle: _getPdfSubtitle(),
                icon: AppImage().readerPdf,
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(RouteNames.lessonDetailsPdf, arguments: lesson);
                },
              ),

              verticalSpace(14),

              LessonMaterialTile(
                title: lesson.title,
                subtitle: 'اختبار تدريبي',
                icon: AppImage().exam,
                iconBackground: ColorPalette.accent,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RouteNames.lessonQuiz,
                    arguments: lesson.lessonId,
                  );
                },
              ),

              verticalSpace(28),
            ],
          ),
        ),
      ),
    );
  }

  String _getPdfSubtitle() {
    if (!lesson.hasPdfFile) {
      return 'لا يوجد ملف متاح حاليًا';
    }
    final fileName = lesson.pdfFileName.trim();
    if (fileName.isEmpty) {
      return 'ملف PDF';
    }
    return 'ملف PDF · $fileName';
  }
}
