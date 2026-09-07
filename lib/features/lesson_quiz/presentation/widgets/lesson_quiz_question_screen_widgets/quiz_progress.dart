import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizProgress extends StatelessWidget {
  const QuizProgress({
    super.key,
    required this.current,
    required this.total,
    this.statusText,
    this.statusColor,
  });

  final int current;
  final int total;
  final String? statusText;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : current / total;
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              statusText ?? '%${toArabicNumbers(percentage)} مكتمل',
              style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                color: statusColor ?? ColorPalette.textSecondary,
                fontWeight: statusText != null ? FontWeight.w700 : FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
            ),
            Text(
              'السؤال ${toArabicNumbers(current)} من ${toArabicNumbers(total)}',
              style: AppTextStyle.font14TextPrimarySemiBoldKufam().copyWith(
                color: ColorPalette.primary,
                fontWeight: FontWeight.w700,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        verticalSpace(8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: ColorPalette.paleSage,
              valueColor: const AlwaysStoppedAnimation<Color>(ColorPalette.primary),
            ),
          ),
        ),
      ],
    );
  }
}
