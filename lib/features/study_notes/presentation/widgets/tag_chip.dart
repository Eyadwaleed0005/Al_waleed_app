import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Text(
        label,
        style: AppTextStyle.font12TextPrimaryRegularTajawal().copyWith(
          color: ColorPalette.primary,
          fontWeight: FontWeightHelper.medium,
        ),
      ),
    );
  }
}
