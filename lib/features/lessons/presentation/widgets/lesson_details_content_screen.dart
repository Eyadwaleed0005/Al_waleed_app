import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_content_tile.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_overview_card.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonDetailsContentScreen extends StatelessWidget {
  const LessonDetailsContentScreen({super.key});

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
                    'الكيمياء العضوية',
                    style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Text(
                'أنواع المواد العضوية',
                style: AppTextStyle.font14TextSecondaryRegularTajawal(),
              ),
              verticalSpace(12),
              const LessonVideoCard(
                videoUrl: 'https://youtu.be/M6uaEUYMwo0?si=piLQ0iJoczQBifwQ',
              ),
              verticalSpace(20),
              const LessonOverviewCard(),
              verticalSpace(76),
              Text(
                'محتوى الدرس',
                textAlign: TextAlign.right,
                style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
              ),
              verticalSpace(14),
              LessonContentTile(
                title: 'ملخص الدرس',
                subtitle: 'ملف PDF · مقدمة الكيمياء العضوية',
                icon: AppImage().readerPdf,
                onTap: () {
                  Navigator.of(context).pushNamed(RouteNames.lessonDetailsPdf);
                },
              ),
              verticalSpace(14),
              LessonContentTile(
                title: 'اختبار الكيمياء العضوية',
                subtitle: 'سؤال · ٤ درجات',
                icon: AppImage().exam,
                iconBackground: ColorPalette.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
