import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText = 'ابحث...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
        color: ColorPalette.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintTextDirection: TextDirection.rtl,
        hintStyle: AppTextStyle.font14TextSecondaryRegularTajawal(),
        prefixIcon:
            prefixIcon ??
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Image.asset(
                AppImage().search,
                width: 20.w,
                height: 20.w,
                fit: BoxFit.contain,
              ),
            ),
        suffixIcon: controller != null && (controller?.text.isNotEmpty ?? false)
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: ColorPalette.textMuted,
                  size: 20.sp,
                ),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: ColorPalette.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorPalette.border, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorPalette.border, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorPalette.primary, width: 1.5.w),
        ),
      ),
    );
  }
}
