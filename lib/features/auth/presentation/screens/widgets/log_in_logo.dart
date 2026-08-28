import 'package:al_waleed/core/style/app_asset.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLogInLogo extends StatelessWidget {
  const CustomLogInLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w,
      height: 110.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: ColorPalette.highlight, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Image.asset(AppAsset.logo, fit: BoxFit.cover),
      ),
    );
  }
}
