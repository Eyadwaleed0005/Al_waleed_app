import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.prefixIcon,
    this.suffixIcon,
    this.foreground,
    this.background,
    this.borderColor,
    this.borderWidth,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? foreground;
  final Color? background;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background ?? ColorPalette.primary,
          disabledBackgroundColor: ColorPalette.disabled,
          foregroundColor: foreground ?? ColorPalette.textLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: borderWidth ?? 1.5.w)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  color: foreground ?? ColorPalette.textLight,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[prefixIcon!, horizontalSpace(8)],
                  Text(
                    text,
                    style: AppTextStyle.font15TextLightBoldTajawal().copyWith(
                      color: foreground,
                    ),
                  ),
                  if (suffixIcon != null) ...[horizontalSpace(8), suffixIcon!],
                ],
              ),
      ),
    );
  }
}
