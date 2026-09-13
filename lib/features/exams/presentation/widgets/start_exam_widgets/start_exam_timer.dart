import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartExamTimer extends StatelessWidget {
  final String remainingTime;
  const StartExamTimer({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      height: 45.h,

      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorPalette.deepOlive,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            remainingTime,
            style: AppTextStyle.font13TextHighlightBoldTajawal(),
          ),
          horizontalSpace(6),
          Flexible(
            child: Icon(
              Icons.access_time_rounded,
              size: 16.sp,
              color: ColorPalette.goldHighlight,
            ),
          ),
        ],
      ),
    );
  }
}
