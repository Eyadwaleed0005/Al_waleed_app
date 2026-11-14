import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileActionCard extends StatelessWidget {
  const ProfileActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showArrow = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.cardBackground,
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, size: 24.sp, color: ColorPalette.primary),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.font14TextPrimarySemiBoldKufam(),
                    ),
                    verticalSpace(4),
                    Text(
                      subtitle,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                    ),
                  ],
                ),
              ),
              if (showArrow) ...[
                horizontalSpace(8),
                Icon(
                  Icons.chevron_left_rounded,
                  size: 22.sp,
                  color: ColorPalette.primary,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
