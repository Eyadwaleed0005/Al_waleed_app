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
  });

  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorPalette.primarySoftBackground,
          foregroundColor: ColorPalette.primary,
          side: BorderSide(color: ColorPalette.border, width: 1.5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  color: ColorPalette.primary,
                  strokeWidth: 2.5,
                ),
                child: CircularProgressIndicator(
                  color: ColorPalette.primary,
                  strokeWidth: 2.5,
                ),
              )
            : child ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20.sp, color: ColorPalette.primary),
                      ],
                      Text(
                        text ?? '',
                        style: AppTextStyle.font15TextLightBoldTajawal()
                            .copyWith(color: ColorPalette.primary),
                      ),
                    ],
                  ),
      ),
    );
  }
}
