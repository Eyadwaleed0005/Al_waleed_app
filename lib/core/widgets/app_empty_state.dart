import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? footer;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double iconContainerSize;
  final double iconSize;
  final double iconTitleSpacing;
  final double titleSubtitleSpacing;
  final double footerSpacing;

  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    this.footer,
    this.actionText,
    this.onAction,
    this.iconColor,
    this.iconBackgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.iconContainerSize = 70,
    this.iconSize = 34,
    this.iconTitleSpacing = 20,
    this.titleSubtitleSpacing = 8,
    this.footerSpacing = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconContainerSize.w,
              height: iconContainerSize.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    iconBackgroundColor ?? ColorPalette.primarySoftBackground,
                shape: BoxShape.circle,
              ),
              child:
                  iconWidget ??
                  Icon(
                    icon ?? Icons.inbox_rounded,
                    size: iconSize.sp,
                    color: iconColor ?? ColorPalette.primary,
                  ),
            ),
            verticalSpace(iconTitleSpacing),
            Text(
              title,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: titleStyle ?? AppTextStyle.font20TextBlackSemiBoldKufam(),
            ),
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
              verticalSpace(titleSubtitleSpacing),
              Text(
                subtitle!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style:
                    subtitleStyle ??
                    AppTextStyle.font14TextSecondaryRegularTajawal(),
              ),
            ],
            if (actionText != null && onAction != null) ...[
              verticalSpace(24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                  foregroundColor: ColorPalette.cardBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
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
            if (footer != null) ...[verticalSpace(footerSpacing), footer!],
          ],
        ),
      ),
    );
  }
}
