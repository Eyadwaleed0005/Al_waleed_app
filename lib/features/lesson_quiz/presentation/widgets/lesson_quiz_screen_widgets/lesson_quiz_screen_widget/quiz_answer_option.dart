import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizAnswerOption extends StatelessWidget {
  const QuizAnswerOption({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
    this.isCorrect,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorPalette.surface;
    Color borderColor = ColorPalette.divider;
    Color textColor = ColorPalette.textPrimary;
    Color indicatorColor = ColorPalette.textMuted;
    Color? innerDotColor;

    if (isCorrect != null) {
      if (isCorrect == true) {
        backgroundColor = const Color(0xFFE8F8F0);
        borderColor = ColorPalette.success;
        textColor = ColorPalette.success;
        indicatorColor = ColorPalette.success;
        innerDotColor = ColorPalette.success;
      } else {
        backgroundColor = const Color(0xFFFFEBEE);
        borderColor = ColorPalette.error;
        textColor = ColorPalette.error;
        indicatorColor = ColorPalette.error;
        innerDotColor = ColorPalette.error;
      }
    } else if (isSelected) {
      backgroundColor = const Color(0xFFE8F8F0);
      borderColor = ColorPalette.success;
      textColor = ColorPalette.success;
      indicatorColor = ColorPalette.success;
      innerDotColor = ColorPalette.success;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: borderColor,
              width: (isSelected || isCorrect != null) ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: indicatorColor, width: 2.w),
                ),
                child: innerDotColor != null
                    ? Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: innerDotColor,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              horizontalSpace(12),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font15TextPrimaryMediumTajawal().copyWith(
                    color: textColor,
                    fontWeight: (isSelected || isCorrect != null)
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
