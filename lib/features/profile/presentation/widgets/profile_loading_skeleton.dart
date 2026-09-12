import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.border,
      highlightColor: ColorPalette.cardBackground,
      child: Column(
        children: [
          _SkeletonBox(width: 190.w, height: 24.h, borderRadius: 8.r),
          verticalSpace(10),
          _SkeletonBox(width: 130.w, height: 14.h, borderRadius: 6.r),
          verticalSpace(32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorPalette.cardBackground,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: const Column(
              children: [
                _ProfileInfoRowSkeleton(),
                _ProfileInfoRowSkeleton(),
                _ProfileInfoRowSkeleton(),
                _ProfileInfoRowSkeleton(showDivider: false),
              ],
            ),
          ),
          verticalSpace(38),
          _SkeletonBox(
            width: double.infinity,
            height: 52.h,
            borderRadius: 16.r,
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRowSkeleton extends StatelessWidget {
  final bool showDivider;

  const _ProfileInfoRowSkeleton({this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _SkeletonBox(width: 26.r, height: 26.r, borderRadius: 8.r),
              horizontalSpace(12),
              _SkeletonBox(width: 92.w, height: 14.h, borderRadius: 5.r),
              const Spacer(),
              _SkeletonBox(width: 105.w, height: 14.h, borderRadius: 5.r),
            ],
          ),
        ),
        if (showDivider)
          Container(
            width: double.infinity,
            height: 1.h,
            color: ColorPalette.border,
          ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
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
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
