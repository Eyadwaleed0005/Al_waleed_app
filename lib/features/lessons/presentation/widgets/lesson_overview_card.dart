import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonOverviewCard extends StatelessWidget {
  const LessonOverviewCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(18.w),
    decoration: BoxDecoration(
      color: ColorPalette.surface,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: ColorPalette.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'عن الدرس',
              style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
            ),
            horizontalSpace(10),
            Container(width: 4.w, height: 24.h, color: ColorPalette.accent),
          ],
        ),
        verticalSpace(10),
        Text(
          'مقدمة منظمة للكيمياء العضوية تشمل الهيدروكربونات، الكحولات، الفينولات، الأحماض العضوية والاسترات.',
          textAlign: TextAlign.right,
          style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
            height: 1.7,
          ),
        ),
      ],
    ),
  );
}
