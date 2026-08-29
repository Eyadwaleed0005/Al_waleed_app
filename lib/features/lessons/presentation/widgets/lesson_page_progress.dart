import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonPageProgress extends StatelessWidget {
  const LessonPageProgress({super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(top: 14.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
    decoration: BoxDecoration(
      color: ColorPalette.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: ColorPalette.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'الصفحة 1 من 8',
          style: AppTextStyle.font14TextPrimaryMediumKufam(),
        ),
        SizedBox(height: 9.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: const LinearProgressIndicator(
            value: .92,
            minHeight: 4,
            valueColor: AlwaysStoppedAnimation(ColorPalette.border),
            backgroundColor: ColorPalette.primary,
          ),
        ),
      ],
    ),
  );
}
