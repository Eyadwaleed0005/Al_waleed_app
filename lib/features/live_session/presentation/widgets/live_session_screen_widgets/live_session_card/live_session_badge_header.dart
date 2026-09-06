import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/style/app_color.dart';

class LiveSessionBadgeHeader extends StatelessWidget {
  const LiveSessionBadgeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ColorPalette.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LIVE',
                style: AppTextStyle.font11TextHighlightBoldTajawal().copyWith(
                  color: ColorPalette.error,
                ),
              ),
              horizontalSpace(8.w),
              Badge(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorPalette.primarySoftBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(
            Icons.video_call_outlined,
            color: ColorPalette.secondary,
          ),
        ),
      ],
    );
  }
}
