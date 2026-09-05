
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoSessionNoticeCard extends StatelessWidget {
  const NoSessionNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '.ارجع في موعد الحصة المعلن',
            style: AppTextStyle.font12TextLightMediumTajawal().copyWith(
              color: ColorPalette.textBlack,
            ),
          ),
          const Icon(
            Icons.access_time_rounded,
            color: ColorPalette.secondary,
            size: 30,
          ),
        ],
      ),
    );
  }
}