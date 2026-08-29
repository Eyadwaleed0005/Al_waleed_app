import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonCategoryCard extends StatelessWidget {
  const LessonCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 83.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorPalette.lightYellow, ColorPalette.highlight],
            stops: [0.7, 1],
          ),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: const [
            BoxShadow(
              color: ColorPalette.ligthBlackShadow,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.font15TextBlackSemiBoldKufam(),
                  ),
                  verticalSpace(7),
                  Text(
                    subtitle,
                    style: AppTextStyle.font15TextMutedRegularTajawal()
                        .copyWith(color: ColorPalette.textBlack),
                  ),
                ],
              ),
            ),
            horizontalSpace(16),
            Opacity(
              opacity: .35,
              child: Icon(
                Icons.science_outlined,
                size: 54.sp,
                color: ColorPalette.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
