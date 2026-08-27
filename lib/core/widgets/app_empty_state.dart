import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  color: ColorPalette.primarySoftBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.inbox_rounded,
                  size: 30.sp,
                  color: ColorPalette.primary.withOpacity(0.6),
                ),
              ),
              verticalSpace(12),
              Text(
                title,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
              ),
              if (subtitle != null) ...[
                verticalSpace(6),
                Text(
                  subtitle!,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                ),
              ],
              if (actionText != null && onAction != null) ...[
                verticalSpace(16),
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: AppTextStyle.font15TextLightBoldTajawal(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
