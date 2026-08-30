
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoLiveBadgeHeader extends StatelessWidget {
  const NoLiveBadgeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: ColorPalette.secondary.withValues(alpha: 0.06),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.video_call_outlined,
        size: 60,
        color: ColorPalette.secondary,
      ),
    );
  }
}
