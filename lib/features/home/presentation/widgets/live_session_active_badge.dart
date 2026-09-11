import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionActiveBadge extends StatelessWidget {
  const LiveSessionActiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ColorPalette.error,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.error.withValues(alpha: 0.30),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(
                    onPlay: (controller) {
                      controller.repeat(reverse: true);
                    },
                  )
                  .fade(begin: 0.35, end: 1, duration: 600.ms)
                  .scaleXY(begin: 0.75, end: 1.15, duration: 600.ms),
              horizontalSpace(6),
              Text(
                'مباشر',
                style: AppTextStyle.font12TextPrimaryRegularTajawal().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        )
        .animate(
          onPlay: (controller) {
            controller.repeat();
          },
        )
        .shake(
          duration: 1600.ms,
          hz: 1.5,
          offset: Offset(1.5.w, 0),
          curve: Curves.easeInOut,
        );
  }
}
