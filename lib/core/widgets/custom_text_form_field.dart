import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.textDirection,
    this.initialValue,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool isPassword;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final String? initialValue;
  final FocusNode? focusNode;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool showPasswordToggle = widget.isPassword;
    final bool isObscured = widget.isPassword && _obscureText;

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      obscureText: isObscured,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      textDirection: widget.textDirection ?? TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeightHelper.regular,
        fontFamily: AppTextStyle.tajawal,
        color: ColorPalette.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintTextDirection: widget.textDirection ?? TextDirection.rtl,
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeightHelper.medium,
          fontFamily: AppTextStyle.tajawal,
          color: ColorPalette.textSecondary,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeightHelper.semiBold,
          fontFamily: AppTextStyle.tajawal,
          color: ColorPalette.primary,
        ),
        hintStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeightHelper.regular,
          fontFamily: AppTextStyle.tajawal,
          color: ColorPalette.textMuted,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: showPasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: ColorPalette.textMuted,
                  size: 22.sp,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: widget.suffixIcon,
                  )
                : null,
        filled: true,
        fillColor: widget.enabled
            ? ColorPalette.surface
            : ColorPalette.primarySoftBackground,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorPalette.error, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorPalette.error, width: 1.5.w),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorPalette.divider, width: 1.w),
        ),
        errorStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeightHelper.regular,
          fontFamily: AppTextStyle.tajawal,
          color: ColorPalette.error,
        ),
      ),
    );
  }
}
