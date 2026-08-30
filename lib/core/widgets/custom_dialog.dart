import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CustomDialogType { confirm, success, delete, notice }

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = CustomDialogType.confirm,
    this.primaryButtonText,
    this.secondaryButtonText = 'إلغاء',
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.customIcon,
    this.iconColor,
    this.iconBgColor,
    this.iconBorderRadius,
  });

  final String title;
  final String message;
  final CustomDialogType type;
  final String? primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final IconData? customIcon;
  final Color? iconColor;
  final Color? iconBgColor;
  final BorderRadiusGeometry? iconBorderRadius;

  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String primaryText = 'تأكيد',
    String secondaryText = 'إلغاء',
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    BorderRadiusGeometry? iconBorderRadius,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.confirm,
        title: title,
        message: message,
        primaryButtonText: primaryText,
        secondaryButtonText: secondaryText,
        customIcon: icon,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        iconBorderRadius: iconBorderRadius,
        onPrimaryPressed: () {
          Navigator.of(context).pop(true);
          onConfirm?.call();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }

  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'تم',
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    BorderRadiusGeometry? iconBorderRadius,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.success,
        title: title,
        message: message,
        primaryButtonText: buttonText,
        customIcon: icon,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        iconBorderRadius: iconBorderRadius,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
      ),
    );
  }

  static Future<bool?> showDelete(
    BuildContext context, {
    required String title,
    required String message,
    String primaryText = 'حذف',
    String secondaryText = 'إلغاء',
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    BorderRadiusGeometry? iconBorderRadius,
    VoidCallback? onDelete,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.delete,
        title: title,
        message: message,
        primaryButtonText: primaryText,
        secondaryButtonText: secondaryText,
        customIcon: icon ?? Icons.info_outline,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        iconBorderRadius: iconBorderRadius,
        onPrimaryPressed: () {
          Navigator.of(context).pop(true);
          onDelete?.call();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }

  static Future<void> showNotice(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'فهمت',
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    BorderRadiusGeometry? iconBorderRadius,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.notice,
        title: title,
        message: message,
        primaryButtonText: buttonText,
        customIcon: icon,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        iconBorderRadius: iconBorderRadius,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
      ),
    );
  }

  Color get _resolvedIconBgColor {
    if (iconBgColor != null) return iconBgColor!;
    return switch (type) {
      CustomDialogType.confirm => const Color(0xFFE8F3FB),
      CustomDialogType.success => const Color(0xFFE6F4EE),
      CustomDialogType.delete => const Color(0xFFFBEAEA),
      CustomDialogType.notice => const Color(0xFFE8F3FB),
    };
  }

  Color get _resolvedIconColor {
    if (iconColor != null) return iconColor!;
    return switch (type) {
      CustomDialogType.confirm => ColorPalette.secondary,
      CustomDialogType.success => ColorPalette.primary,
      CustomDialogType.delete => ColorPalette.error,
      CustomDialogType.notice => ColorPalette.secondary,
    };
  }

  IconData get _resolvedIconData {
    if (customIcon != null) return customIcon!;
    return switch (type) {
      CustomDialogType.confirm => Icons.info_outline_rounded,
      CustomDialogType.success => Icons.check_circle_outline_rounded,
      CustomDialogType.delete => Icons.logout_rounded,
      CustomDialogType.notice => Icons.info_outline_rounded,
    };
  }

  String get _defaultPrimaryText {
    return switch (type) {
      CustomDialogType.confirm => 'تأكيد',
      CustomDialogType.success => 'تم',
      CustomDialogType.delete => 'تسجيل الخروج',
      CustomDialogType.notice => 'فهمت',
    };
  }

  bool get _isSingleButton =>
      type == CustomDialogType.success || type == CustomDialogType.notice;

  @override
  Widget build(BuildContext context) {
    final String mainBtnText = primaryButtonText ?? _defaultPrimaryText;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorPalette.divider,
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            verticalSpace(16),

            Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _resolvedIconBgColor,
                shape: iconBorderRadius == null
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                borderRadius: iconBorderRadius,
              ),
              child: Icon(
                _resolvedIconData,
                color: _resolvedIconColor,
                size: 32.sp,
              ),
            ),
            verticalSpace(16),

            Text(
              title,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
            ),
            verticalSpace(8),

            Text(
              message,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTextStyle.font14TextSecondaryRegularTajawal(),
            ),
            verticalSpace(24),

            if (_isSingleButton)
              CustomButton(
                text: mainBtnText,
                onPressed:
                    onPrimaryPressed ?? () => Navigator.of(context).pop(),
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: type == CustomDialogType.delete
                        ? ElevatedButton(
                            onPressed: onPrimaryPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.error,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              mainBtnText,
                              style: AppTextStyle.font15TextLightBoldTajawal(),
                            ),
                          )
                        : CustomButton(
                            text: mainBtnText,
                            onPressed: onPrimaryPressed,
                          ),
                  ),
                  verticalSpace(12),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: CustomSecondaryButton(
                      text: secondaryButtonText,
                      onPressed:
                          onSecondaryPressed ??
                          () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            verticalSpace(8),
          ],
        ),
      ),
    );
  }
}
