import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartExamProgressHeader extends StatelessWidget {
  const StartExamProgressHeader({
    super.key,
    this.currentQuestion = 6,
    this.totalQuestions = 20,
    this.completionPercentage = 30,
  });

  final int currentQuestion;
  final int totalQuestions;
  final int completionPercentage;

  @override
  Widget build(BuildContext context) {
    final progressValue = totalQuestions > 0
        ? (currentQuestion / totalQuestions).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${toArabicNumbers(currentQuestion)} من ${toArabicNumbers(totalQuestions)}',
                style: AppTextStyle.font13TextPrimaryBoldTajawal(),
              ),
              Text(
                '$completionPercentage% مكتمل',
                style: AppTextStyle.font11TextSecondaryRegularTajawal(),
              ),
            ],
          ),
        ),
        verticalSpace(8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6.h,
              backgroundColor: ColorPalette.background.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorPalette.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
