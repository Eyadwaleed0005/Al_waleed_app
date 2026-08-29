import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonContentTile extends StatelessWidget {
  const LessonContentTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconBackground = ColorPalette.primarySoftBackground,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final String icon;
  final Color iconBackground;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Image.asset(icon, height: 24.h, width: 24.w),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
                ),
                SizedBox(height: 5.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
