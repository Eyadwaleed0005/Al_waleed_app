import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySubscriptionStatusCard extends StatelessWidget {
  const MySubscriptionStatusCard({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final statusColor = isActive
        ? ColorPalette.primary
        : ColorPalette.textSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isActive
              ? ColorPalette.softSage.withValues(alpha: 0.55)
              : ColorPalette.border,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.05),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIllustration(statusColor),
          verticalSpace(24),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isActive ? ColorPalette.paleSage : ColorPalette.fogWhite,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Text(
              isActive ? 'اشتراك نشط' : 'اشتراك غير مفعّل',
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          verticalSpace(16),
          Text(
            isActive ? 'اشتراكك سارٍ!' : 'مستنيينك ترجع تتعلّم',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font18TextPrimarySemiBoldKufam().copyWith(
              color: ColorPalette.primary,
            ),
          ),
          verticalSpace(12),
          Text(
            isActive
                ? 'كمّل رحلتك في فهم الكيمياء، '
                      'محتوى اشتراكك متاح ليك.'
                : 'اشتراكك غير مفعّل حاليًا.\n'
                      'تواصل مع المعلّم لتفعيل الاشتراك أو تجديده، '
                      'وكمّل رحلتك معانا.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIllustration(Color statusColor) {
    return SizedBox(
      width: 144.r,
      height: 144.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 144.r,
            height: 144.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? ColorPalette.paleMint : ColorPalette.fogWhite,
            ),
          ),
          Container(
            width: 112.r,
            height: 112.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? ColorPalette.paleSage : ColorPalette.sageGray,
            ),
            child: Icon(
              isActive
                  ? Icons.sentiment_very_satisfied_rounded
                  : Icons.sentiment_dissatisfied_rounded,
              size: 72.sp,
              color: statusColor,
            ),
          ),
          Positioned(
            right: 9.r,
            bottom: 10.r,
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? ColorPalette.primary
                    : ColorPalette.textSecondary,
                border: Border.all(
                  color: ColorPalette.cardBackground,
                  width: 4.r,
                ),
              ),
              child: Icon(
                isActive ? Icons.check_rounded : Icons.lock_outline_rounded,
                size: 19.sp,
                color: ColorPalette.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
