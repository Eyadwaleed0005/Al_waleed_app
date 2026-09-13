import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartExamProgressHeader extends StatelessWidget {
  const StartExamProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.completionPercentage,
  });

  final int currentQuestion;
  final int totalQuestions;
  final int completionPercentage;

  @override
  Widget build(BuildContext context) {
    final double progressValue = totalQuestions > 0
        ? (currentQuestion / totalQuestions).clamp(0.0, 1.0).toDouble()
        : 0;

    final int normalizedPercentage = completionPercentage.clamp(0, 100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${toArabicNumbers(currentQuestion)} من '
                '${toArabicNumbers(totalQuestions)}',
                style: AppTextStyle.font13TextPrimaryBoldTajawal(),
              ),
              Text(
                '${toArabicNumbers(normalizedPercentage)}٪ مكتمل',
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
