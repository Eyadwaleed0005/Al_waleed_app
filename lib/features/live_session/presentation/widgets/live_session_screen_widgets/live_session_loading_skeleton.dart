import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionLoadingSkeleton extends StatelessWidget {
  const LiveSessionLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: ColorPalette.cardBackground,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.ligthBlackShadow.withOpacity(0.12),
                blurRadius: 16.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LoadingSkeleton(
                    width: 76.w,
                    height: 28.h,
                    borderRadius: 20.r,
                  ),
                  _LoadingSkeleton(
                    width: 54.w,
                    height: 54.h,
                    borderRadius: 16.r,
                  ),
                ],
              ),
              verticalSpace(20),
              _LoadingSkeleton(width: 170.w, height: 22.h, borderRadius: 6.r),
              verticalSpace(10),
              _LoadingSkeleton(width: 115.w, height: 13.h, borderRadius: 5.r),
              verticalSpace(38),
              _LoadingSkeleton(width: 65.w, height: 12.h, borderRadius: 5.r),
              verticalSpace(12),
              _LoadingSkeleton(
                width: double.infinity,
                height: 52.h,
                borderRadius: 15.r,
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1400.ms,
          color: ColorPalette.surface.withOpacity(0.75),
        );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _LoadingSkeleton({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.sageGray,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
