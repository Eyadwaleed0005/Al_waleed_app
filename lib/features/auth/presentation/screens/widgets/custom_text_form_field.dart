import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/style/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isObscureText = false,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.font13TextPrimaryMediumTajawal()),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            obscureText: isObscureText,
            validator: validator,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyle.font14TextBlackRegularTajawal(),
            decoration: InputDecoration(
              hintText: hintText,
              hintTextDirection: TextDirection.rtl,
              hintStyle: AppTextStyle.font15TextMutedRegularTajawal(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              fillColor: ColorPalette.surface,
              filled: true,
              prefixIcon: prefixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorPalette.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorPalette.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorPalette.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorPalette.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
