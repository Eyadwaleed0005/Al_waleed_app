import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/exams/presentation/widgets/current_exam_widgets/available_exam_card.dart';
import 'package:al_waleed/features/exams/presentation/widgets/current_exam_widgets/current_exam_empty_view.dart';
import 'package:al_waleed/features/exams/presentation/widgets/current_exam_widgets/exam_auto_save_notice.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsScreenContent extends StatelessWidget {
  final bool isEmpty;
  const ExamsScreenContent({super.key, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "الامتحان الحالي",
              centerTitle: true,
              showBackButton: false,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: SafeArea(
                child: isEmpty
                    ? const CurrentExamEmptyView()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppAnimations.screenSection(
                              delay: 100,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'اختبار متاح الآن',
                                  style:
                                      AppTextStyle.font13TextOceanBlueBoldTajawal(),
                                ),
                              ),
                            ),
                            verticalSpace(12),
                            AppAnimations.screenSection(
                              delay: 200,
                              child: const AvailableExamCard(),
                            ),
                            verticalSpace(18),
                            AppAnimations.screenSection(
                              delay: 300,
                              child: const ExamAutoSaveNotice(),
                            ),
                            verticalSpace(22),
                            AppAnimations.screenSection(
                              delay: 400,
                              child: CustomButton(
                                text: 'ابدأ الامتحان',
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(RouteNames.startExamScreen);
                                },
                                background: ColorPalette.primary,
                                foreground: ColorPalette.textLight,
                                height: 52.h,
                              ),
                            ),
                            verticalSpace(10),
                            AppAnimations.screenSection(
                              delay: 450,
                              child: Text(
                                'بمجرد البدء سيعمل المؤقت ولا يمكن إيقافه.',
                                textAlign: TextAlign.center,
                                style:
                                    AppTextStyle.font11TextSecondaryRegularTajawal(),
                              ),
                            ),
                            verticalSpace(16),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
