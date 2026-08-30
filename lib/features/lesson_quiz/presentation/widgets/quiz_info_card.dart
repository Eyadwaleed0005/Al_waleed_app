import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizInfoCard extends StatelessWidget {
  const QuizInfoCard({
    super.key,
    required this.scoreText,
    required this.retryText,
  });

  final String scoreText;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorPalette.divider, width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'الدرجة',
                style: AppTextStyle.font13TextSecondaryRegularTajawal().copyWith(
                  color: ColorPalette.textSecondary,
                ),
                textDirection: TextDirection.rtl,
              ),
              Text(
                scoreText,
                style: AppTextStyle.font14TextPrimaryMediumTajawal().copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorPalette.textPrimary,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          Divider(height: 24.h, color: ColorPalette.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'إعادة المحاولة',
                style: AppTextStyle.font13TextSecondaryRegularTajawal().copyWith(
                  color: ColorPalette.textSecondary,
                ),
                textDirection: TextDirection.rtl,
              ),
              Text(
                retryText,
                style: AppTextStyle.font14TextPrimaryMediumTajawal().copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorPalette.textPrimary,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
