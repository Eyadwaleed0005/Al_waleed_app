import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsScreenLoadingSkeleton extends StatefulWidget {
  const ExamsScreenLoadingSkeleton({super.key});

  @override
  State<ExamsScreenLoadingSkeleton> createState() {
    return _ExamsScreenLoadingSkeletonState();
  }
}

class _ExamsScreenLoadingSkeletonState extends State<ExamsScreenLoadingSkeleton>
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
      builder: (BuildContext context, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _buildSkeletonBox(
                width: 120.w,
                height: 14.h,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ),
            verticalSpace(14),
            _buildExamItemSkeleton(),
          ],
        );
      },
    );
  }

  Widget _buildExamItemSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildExamCardSkeleton(),
        verticalSpace(16),
        _buildAutoSaveNoticeSkeleton(),
        verticalSpace(18),
        _buildSkeletonBox(
          height: 52.h,
          borderRadius: BorderRadius.circular(14.r),
        ),
        verticalSpace(10),
        Align(
          alignment: Alignment.center,
          child: _buildSkeletonBox(
            width: 210.w,
            height: 10.h,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ],
    );
  }

  Widget _buildExamCardSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.06),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSkeletonBox(
            width: 82.w,
            height: 24.h,
            borderRadius: BorderRadius.circular(20.r),
          ),
          verticalSpace(16),
          _buildSkeletonBox(
            width: 210.w,
            height: 20.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
          verticalSpace(8),
          _buildSkeletonBox(
            width: 130.w,
            height: 12.h,
            borderRadius: BorderRadius.circular(6.r),
          ),
          verticalSpace(22),
          Row(
            children: [
              Expanded(child: _buildExamStatSkeleton()),
              horizontalSpace(10),
              Expanded(child: _buildExamStatSkeleton()),
              horizontalSpace(10),
              Expanded(child: _buildExamStatSkeleton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamStatSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorPalette.background,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _buildSkeletonBox(
            width: 34.w,
            height: 16.h,
            borderRadius: BorderRadius.circular(6.r),
          ),
          verticalSpace(7),
          _buildSkeletonBox(
            width: 48.w,
            height: 10.h,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSaveNoticeSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorPalette.oceanBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _buildSkeletonBox(
            width: 28.r,
            height: 28.r,
            borderRadius: BorderRadius.circular(14.r),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildSkeletonBox(
                  width: 190.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                verticalSpace(7),
                _buildSkeletonBox(
                  width: 150.w,
                  height: 10.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ],
            ),
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
    final double movement = _animationController.value * 3;

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
          stops: const [0.2, 0.5, 0.8],
        ),
      ),
    );
  }
}
