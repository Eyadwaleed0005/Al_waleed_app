import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesLoadingSkeleton extends StatefulWidget {
  const StudyNotesLoadingSkeleton({super.key});

  @override
  State<StudyNotesLoadingSkeleton> createState() {
    return _StudyNotesLoadingSkeletonState();
  }
}

class _StudyNotesLoadingSkeletonState
    extends State<StudyNotesLoadingSkeleton>
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
              padding: EdgeInsets.only(bottom: 14.h),
              child: _buildCardSkeleton(),
            );
          }),
        );
      },
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      width: double.infinity,
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
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(width: 5.w, color: ColorPalette.highlight),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    verticalSpace(20),
                    Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildSkeletonBox(
                          width: 80.w,
                          height: 36.h,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSkeletonBox(
                              width: 30.w,
                              height: 30.h,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            verticalSpace(5),
                            _buildSkeletonBox(
                              width: 44.w,
                              height: 10.h,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

