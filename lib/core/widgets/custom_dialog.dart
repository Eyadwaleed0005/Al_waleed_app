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
  });

  final String title;
  final String message;
  final CustomDialogType type;
  final String? primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final IconData? customIcon;

  /// 1. Action Confirmation Dialog
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String primaryText = 'تأكيد',
    String secondaryText = 'إلغاء',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.confirm,
        title: title,
        message: message,
        primaryButtonText: primaryText,
        secondaryButtonText: secondaryText,
        onPrimaryPressed: () {
          Navigator.of(context).pop(true);
          onConfirm?.call();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }

  /// 2. Operation Success Dialog
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'تم',
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.success,
        title: title,
        message: message,
        primaryButtonText: buttonText,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
      ),
    );
  }

  /// 3. Confirm Delete Dialog
  static Future<bool?> showDelete(
    BuildContext context, {
    required String title,
    required String message,
    String primaryText = 'حذف',
    String secondaryText = 'إلغاء',
    VoidCallback? onDelete,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.delete,
        title: title,
        message: message,
        primaryButtonText: primaryText,
        secondaryButtonText: secondaryText,
        onPrimaryPressed: () {
          Navigator.of(context).pop(true);
          onDelete?.call();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }

  /// 4. Notice / Warning Dialog (تنبيه)
  static Future<void> showNotice(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'فهمت',
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => CustomDialog(
        type: CustomDialogType.notice,
        title: title,
        message: message,
        primaryButtonText: buttonText,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
      ),
    );
  }

  Color get _iconBgColor {
    return switch (type) {
      CustomDialogType.confirm => const Color(0xFFE8F3FB), // Light Blue
      CustomDialogType.success => const Color(0xFFE6F4EE), // Light Green
      CustomDialogType.delete => const Color(0xFFFBEAEA), // Light Red
      CustomDialogType.notice => const Color(0xFFE8F3FB), // Light Blue
    };
  }

  Color get _iconColor {
    return switch (type) {
      CustomDialogType.confirm => ColorPalette.secondary, // Blue #28729F
      CustomDialogType.success => ColorPalette.primary, // Green #023A22
      CustomDialogType.delete => ColorPalette.error, // Red #C0392B
      CustomDialogType.notice => ColorPalette.secondary, // Blue #28729F
    };
  }

  IconData get _iconData {
    if (customIcon != null) return customIcon!;
    return switch (type) {
      CustomDialogType.confirm => Icons.info_outline_rounded,
      CustomDialogType.success => Icons.check_circle_outline_rounded,
      CustomDialogType.delete => Icons.error_outline_rounded,
      CustomDialogType.notice => Icons.info_outline_rounded,
    };
  }

  String get _defaultPrimaryText {
    return switch (type) {
      CustomDialogType.confirm => 'تأكيد',
      CustomDialogType.success => 'تم',
      CustomDialogType.delete => 'حذف',
      CustomDialogType.notice => 'فهمت',
    };
  }

  bool get _isSingleButton => type == CustomDialogType.success || type == CustomDialogType.notice;

  @override
  Widget build(BuildContext context) {
    final String mainBtnText = primaryButtonText ?? _defaultPrimaryText;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24.r, offset: Offset(0, 8.h))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Handle Bar (—)
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(color: ColorPalette.divider, borderRadius: BorderRadius.circular(50.r)),
            ),
            verticalSpace(16),

            // Circular Icon Background
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(color: _iconBgColor, shape: BoxShape.circle),
              child: Icon(_iconData, color: _iconColor, size: 32.sp),
            ),
            verticalSpace(16),

            // Title
            Text(
              title,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
            ),
            verticalSpace(8),

            // Subtitle / Message
            Text(
              message,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTextStyle.font14TextSecondaryRegularTajawal(),
            ),
            verticalSpace(24),

            // Actions Buttons
            if (_isSingleButton)
              CustomButton(text: mainBtnText, onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop())
            else
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  // Primary Action Button (Right in RTL)
                  Expanded(
                    child: type == CustomDialogType.delete
                        ? SizedBox(
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: onPrimaryPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette.error,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                              ),
                              child: Text(mainBtnText, style: AppTextStyle.font15TextLightBoldTajawal()),
                            ),
                          )
                        : CustomButton(text: mainBtnText, onPressed: onPrimaryPressed),
                  ),
                  horizontalSpace(12),
                  // Secondary Action Button (Left in RTL)
                  Expanded(
                    child: CustomSecondaryButton(
                      text: secondaryButtonText,
                      onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
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
