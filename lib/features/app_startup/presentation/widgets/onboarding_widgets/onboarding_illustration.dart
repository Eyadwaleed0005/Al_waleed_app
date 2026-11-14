import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: SvgPicture.asset(
        image,
        key: ValueKey(image),
        width: 326.w,
        height: 300.h,
        fit: BoxFit.contain,
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 400));
  }
}
