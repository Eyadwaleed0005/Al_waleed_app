import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizQuestionShimmer extends StatefulWidget {
  const QuizQuestionShimmer({super.key});

  @override
  State<QuizQuestionShimmer> createState() {
    return _QuizQuestionShimmerState();
  }
}

class _QuizQuestionShimmerState extends State<QuizQuestionShimmer>
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
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16.w,
                20.h,
                16.w,
                20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressSkeleton(),
                  verticalSpace(18),
                  _buildQuestionCardSkeleton(),
                  verticalSpace(16),
                  _buildAutoSaveSkeleton(),
                  verticalSpace(18),
                  _buildButtonSkeleton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressSkeleton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSkeletonBox(
              width: 75.w,
              height: 12.h,
              borderRadius: BorderRadius.circular(6.r),
            ),
            _buildSkeletonBox(
              width: 95.w,
              height: 14.h,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ],
        ),
        verticalSpace(12),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 7.h,
              decoration: BoxDecoration(
                color: ColorPalette.paleSage,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildSkeletonBox(
                width: 180.w,
                height: 7.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCardSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14.w,
        26.h,
        14.w,
        28.h,
      ),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: _buildSkeletonBox(
              width: 280.w,
              height: 16.h,
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
          verticalSpace(8),
          Align(
            alignment: Alignment.centerRight,
            child: _buildSkeletonBox(
              width: 190.w,
              height: 16.h,
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
          verticalSpace(28),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: _buildSkeletonBox(
              height: 72.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          verticalSpace(40),
          ...List.generate(4, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == 3 ? 0 : 10.h,
              ),
              child: _buildAnswerSkeleton(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerSkeleton() {
    return Container(
      width: double.infinity,
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: ColorPalette.border,
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _buildSkeletonCircle(
            size: 18.w,
          ),
          horizontalSpace(12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildSkeletonBox(
                width: 125.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSaveSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSkeletonBox(
          width: 165.w,
          height: 10.h,
          borderRadius: BorderRadius.circular(5.r),
        ),
        horizontalSpace(8),
        _buildSkeletonCircle(
          size: 16.w,
        ),
      ],
    );
  }

  Widget _buildButtonSkeleton() {
    return _buildSkeletonBox(
      height: 48.h,
      borderRadius: BorderRadius.circular(16.r),
    );
  }

  Widget _buildSkeletonCircle({
    required double size,
  }) {
    return _buildSkeletonBox(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    required BorderRadius borderRadius,
  }) {
    final movement = _animationController.value * 3;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment(-1.5 + movement, 0),
          end: Alignment(-0.5 + movement, 0),
          colors: const [
            ColorPalette.sageGray,
            ColorPalette.fogWhite,
            ColorPalette.sageGray,
          ],
          stops: const [
            0.2,
            0.5,
            0.8,
          ],
        ),
      ),
    );
  }
}