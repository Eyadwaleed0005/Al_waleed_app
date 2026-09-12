import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsLoadingSkeleton extends StatefulWidget {
  const LessonsLoadingSkeleton({super.key});

  @override
  State<LessonsLoadingSkeleton> createState() {
    return _LessonsLoadingSkeletonState();
  }
}

class _LessonsLoadingSkeletonState
    extends State<LessonsLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 22.h),
              child: _buildCardSkeleton(),
            );
          }),
        );
      },
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      height: 90.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSkeletonBox(
            width: 150.w,
            height: 16.h,
            borderRadius: BorderRadius.circular(7.r),
          ),
          verticalSpace(10),
          _buildSkeletonBox(
            width: 220.w,
            height: 12.h,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    final movement = _animationController.value * 3;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        gradient: LinearGradient(
          begin: Alignment(-1.5 + movement, 0),
          end: Alignment(-0.5 + movement, 0),
          colors: const [
            ColorPalette.sageGray,
            ColorPalette.fogWhite,
            ColorPalette.sageGray,
          ],
          stops: [0.2, 0.5, 0.8],
        ),
      ),
    );
  }
}