import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingIntroText extends StatelessWidget {
  const OnboardingIntroText({
    super.key,
    required this.subtitle,
    required this.title,
    required this.description,
  });

  final String subtitle;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: Column(
          key: ValueKey((subtitle, title, description)),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.font13TextHighlightBoldTajawal(),
            ),
            verticalSpace(12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.font26BackgroundBoldKufam(),
            ),
            verticalSpace(12),
            Text(
              description,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font16TextSoftSagaRegularTajawal(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 400));
  }
}
