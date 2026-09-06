import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Inline validation message shown when the user tries to proceed without
/// selecting an answer.
class QuizValidationMessage extends StatelessWidget {
  const QuizValidationMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorPalette.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: ColorPalette.error.withValues(alpha: 0.40),
            width: 1.w,
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: ColorPalette.error,
              size: 16.sp,
            ),
            horizontalSpace(8),
            Text(
              message,
              style: AppTextStyle.font13TextSecondaryRegularTajawal().copyWith(
                color: ColorPalette.error,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
