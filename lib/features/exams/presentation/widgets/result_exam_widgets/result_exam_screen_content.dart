import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/presentation/widgets/result_exam_widgets/exam_submitted_details_card.dart';
import 'package:al_waleed/features/exams/presentation/widgets/result_exam_widgets/exam_submitted_success_card.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultExamScreenContent extends StatelessWidget {
  const ResultExamScreenContent({super.key, required this.result});

  final StudentExamResultEntity result;

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomAppBar(
                title: 'نتيجة الاختبار',
                backgroundColor: Colors.transparent,
                centerTitle: true,
                showBackButton: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ExamSubmittedSuccessCard(examName: result.examName),
                    verticalSpace(18),
                    ExamSubmittedDetailsCard(result: result),
                    verticalSpace(22),
                    Text(
                      'تعرض هذه النتيجة تفاصيل محاولتك الحالية فقط.',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.font11TextSecondaryRegularTajawal(),
                    ),
                    verticalSpace(28),
                    CustomButton(
                      text: 'العودة للامتحانات',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      background: ColorPalette.primary,
                      foreground: ColorPalette.textLight,
                      height: 52.h,
                    ),
                    verticalSpace(10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
