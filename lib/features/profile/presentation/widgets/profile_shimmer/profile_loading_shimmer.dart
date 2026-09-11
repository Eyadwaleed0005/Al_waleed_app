import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholderColor = ColorPalette.cardBackground;
    final shimmerColor1 = ColorPalette.border;
    final shimmerColor2 = ColorPalette.cardBackground;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Shimmer.fromColors(
          baseColor: shimmerColor1,
          highlightColor: shimmerColor2,
          child: Column(
            children: [
              Container(
                height: 50.h,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: _ProfileShimmerBox(width: 70.w, height: 20.h),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _ProfileShimmerBox(width: 28.r, height: 28.r),
                    ),
                  ],
                ),
              ),
              verticalSpace(50),
              _ProfileShimmerBox(width: 150.w, height: 22.h),
              verticalSpace(10),
              _ProfileShimmerBox(width: 110.w, height: 14.h),
              verticalSpace(32),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Column(
                  children: [
                    _ProfileShimmerBox(width: double.infinity, height: 250.h),
                  ],
                ),
              ),
              verticalSpace(32),
              _ProfileShimmerBox(width: 200.w, height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileShimmerBox extends StatelessWidget {
  const _ProfileShimmerBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
