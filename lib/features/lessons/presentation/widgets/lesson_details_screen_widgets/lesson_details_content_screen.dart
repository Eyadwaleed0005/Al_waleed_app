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
  const LessonDetailsContentScreen({
    super.key,
    required this.lesson,
  });

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAppBar(
                showBackButton: true,
                backgroundColor: Colors.transparent,
                actions: [
                  Text(
                    lesson.title,
                    style:
                        AppTextStyle.font18TextPrimarySemiBoldKufam(),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              // Text(
              //   lesson.description,
              //   style:
              //       AppTextStyle.font14TextSecondaryRegularTajawal(),
              // ),
              verticalSpace(12),
              if (lesson.hasYoutubeVideo) ...[
                LessonVideoCard(videoUrl: lesson.youtubeUrl),
                verticalSpace(20),
              ],
              LessonOverviewCard(
                description: lesson.description,
              ),
              verticalSpace(76),
              Text(
                'محتوى الدرس',
                textAlign: TextAlign.right,
                style:
                    AppTextStyle.font20TextPrimarySemiBoldKufam(),
              ),
              verticalSpace(14),
              if (lesson.hasPdfFile)
                LessonMaterialTile(
                  title: 'ملف الدرس',
                  subtitle: lesson.pdfFileName.isEmpty
                      ? 'ملف PDF'
                      : 'ملف PDF · ${lesson.pdfFileName}',
                  icon: AppImage().readerPdf,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.lessonDetailsPdf,
                      arguments: lesson,
                    );
                  },
                ),
              verticalSpace(14),
              LessonMaterialTile(
                title: 'اختبار الكيمياء العضوية',
                subtitle: 'سؤال · ٤ درجات',
                icon: AppImage().exam,
                iconBackground: ColorPalette.accent,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
