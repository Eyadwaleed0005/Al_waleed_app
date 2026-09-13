import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/exams/presentation/widgets/result_exam_widgets/exam_submitted_details_card.dart';
import 'package:al_waleed/features/exams/presentation/widgets/result_exam_widgets/exam_submitted_success_card.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultExamScreenContent extends StatelessWidget {
  const ResultExamScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              CustomAppBar(
                title: 'تم تسليم الاختبار',
                backgroundColor: Colors.transparent,
                centerTitle: true,
                showBackButton: false,
              ),
              verticalSpace(30),
              const ExamSubmittedSuccessCard(),
              verticalSpace(18),
              const ExamSubmittedDetailsCard(),
              verticalSpace(22),
              Text(
                'نتائج الاختبارات العامة لا تظهر داخل تطبيق الطالب.',
                textAlign: TextAlign.center,
                style: AppTextStyle.font11TextSecondaryRegularTajawal(),
              ),
              const Spacer(),
              CustomButton(
                text: 'العودة للامتحانات',
                onPressed: () => Navigator.of(context).pop(),
                background: ColorPalette.primary,
                foreground: ColorPalette.textLight,
                height: 52.h,
              ),
              verticalSpace(10),
            ],
          ),
        ),
      ),
    );
  }
}
