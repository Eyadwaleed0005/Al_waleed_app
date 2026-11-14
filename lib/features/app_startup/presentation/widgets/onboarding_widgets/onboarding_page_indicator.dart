import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    this.currentIndex = 0,
    this.pageCount = 3,
  });

  final int currentIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentIndex;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Container(
            width: isActive ? 32.w : 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: isActive
                  ? ColorPalette.highlight
                  : ColorPalette.softSage.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        );
      }),
    );
  }
}
