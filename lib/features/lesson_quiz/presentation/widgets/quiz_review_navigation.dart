import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizReviewNavigation extends StatelessWidget {
  const QuizReviewNavigation({
    super.key,
    required this.isFirstQuestion,
    required this.isLastQuestion,
    this.onPrevious,
    required this.onNext,
  });

  final bool isFirstQuestion;
  final bool isLastQuestion;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirstQuestion) ...[
          CustomSecondaryButton(
            text: 'السابق',
            onPressed: onPrevious,
          ),
          verticalSpace(10),
        ],
        CustomButton(
          text: isLastQuestion ? 'إنهاء المراجعة' : 'السؤال التالي',
          onPressed: onNext,
        ),
      ],
    );
  }
}

class QuizReviewHint extends StatelessWidget {
  const QuizReviewHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorPalette.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorPalette.success.withValues(alpha: 0.25),
          width: 1.w,
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: ColorPalette.success,
            size: 16.sp,
          ),
          horizontalSpace(8),
          Expanded(
            child: Text(
              'الإجابة الصحيحة موضحة باللون الأخضر.',
              style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                color: ColorPalette.success,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
