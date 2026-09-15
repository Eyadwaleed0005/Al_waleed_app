import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileLoadingSkeleton extends StatefulWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  State<ProfileLoadingSkeleton> createState() {
    return _ProfileLoadingSkeletonState();
  }
}

class _ProfileLoadingSkeletonState extends State<ProfileLoadingSkeleton>
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
      builder: (context, child) {
        return Column(
          children: [
            _buildSkeletonBox(
              width: 190.w,
              height: 24.h,
              borderRadius: BorderRadius.circular(8.r),
            ),
            verticalSpace(10),
            _buildSkeletonBox(
              width: 130.w,
              height: 14.h,
              borderRadius: BorderRadius.circular(6.r),
            ),
            verticalSpace(32),
            _buildProfileInfoCard(),
            verticalSpace(38),
            _buildSkeletonBox(
              width: double.infinity,
              height: 52.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.06),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileInfoRow(),
          _buildProfileInfoRow(),
          _buildProfileInfoRow(),
          _buildProfileInfoRow(showDivider: false),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow({bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _buildSkeletonBox(
                width: 26.r,
                height: 26.r,
                borderRadius: BorderRadius.circular(8.r),
              ),
              horizontalSpace(12),
              _buildSkeletonBox(
                width: 92.w,
                height: 14.h,
                borderRadius: BorderRadius.circular(5.r),
              ),
              const Spacer(),
              _buildSkeletonBox(
                width: 105.w,
                height: 14.h,
                borderRadius: BorderRadius.circular(5.r),
              ),
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

  Widget _buildSkeletonBox({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    final double movement = _animationController.value * 3;

    return Container(
      width: width,
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
