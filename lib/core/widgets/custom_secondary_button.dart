import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSecondaryButton extends StatelessWidget {
  const CustomSecondaryButton({
    super.key,
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.child,
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
  });

  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          backgroundColor: backgroundColor ?? ColorPalette.surface,
          foregroundColor: foregroundColor ?? ColorPalette.primary,
          side: BorderSide(
            color: borderColor ?? ColorPalette.softSage,
            width: 1.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  color: foregroundColor ?? ColorPalette.primary,
                  strokeWidth: 2.5,
                ),
              )
            : child ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 18.sp,
                        color: foregroundColor ?? ColorPalette.primary,
                      ),
                      SizedBox(width: 4.w),
                    ],
                    Flexible(
                      child: Text(
                        text ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.font15TextLightBoldTajawal().copyWith(
                          color: foregroundColor ?? ColorPalette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
