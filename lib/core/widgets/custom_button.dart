import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
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
    final Color buttonBackground = background ?? ColorPalette.primary;

    final Color buttonForeground = foreground ?? ColorPalette.textLight;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackground,
          disabledBackgroundColor: isLoading
              ? buttonBackground
              : ColorPalette.disabled,
          foregroundColor: buttonForeground,
          disabledForegroundColor: buttonForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: borderWidth ?? 1.5.w)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? AppLoadingIndicator(
                color: buttonForeground,
                size: 22,
                strokeWidth: 2.5,
                wavelength: 12,
                waveSpeed: 10,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[prefixIcon!, horizontalSpace(8)],
                  Text(
                    text,
                    style: AppTextStyle.font15TextLightBoldTajawal().copyWith(
                      color: buttonForeground,
                    ),
                  ),
                  if (suffixIcon != null) ...[horizontalSpace(8), suffixIcon!],
                ],
              ),
      ),
    );
  }
}
