import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
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
    final Color resolvedBackgroundColor =
        backgroundColor ?? ColorPalette.surface;

    final Color resolvedForegroundColor =
        foregroundColor ?? ColorPalette.primary;

    final Color resolvedBorderColor = borderColor ?? ColorPalette.softSage;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          backgroundColor: resolvedBackgroundColor,
          disabledBackgroundColor: resolvedBackgroundColor,
          foregroundColor: resolvedForegroundColor,
          disabledForegroundColor: resolvedForegroundColor,
          side: BorderSide(color: resolvedBorderColor, width: 1.5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? AppLoadingIndicator(
                color: resolvedForegroundColor,
                size: 22,
                strokeWidth: 2.5,
                wavelength: 12,
                waveSpeed: 10,
              )
            : child ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18.sp, color: resolvedForegroundColor),
                        SizedBox(width: 4.w),
                      ],
                      Flexible(
                        child: Text(
                          text ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.font15TextLightBoldTajawal()
                              .copyWith(color: resolvedForegroundColor),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
