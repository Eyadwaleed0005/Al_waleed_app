import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        verticalSpace(24),
        _buildActionCard(),
        verticalSpace(10),
        _buildActionCard(showArrow: false),
        verticalSpace(10),
        _buildActionCard(),
        verticalSpace(10),
        _buildActionCard(),
        verticalSpace(10),
        _buildActionCard(showArrow: false),
      ],
    );
  }

  Widget _buildHeader() {
    return _buildShimmer(
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _buildBox(width: 88.w, height: 88.h, radius: 100.r),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBox(width: 140.w, height: 24.h),
                verticalSpace(12),
                _buildBox(width: 170.w, height: 14.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({bool showArrow = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: _buildShimmer(
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildBox(width: 24.w, height: 24.h, radius: 6.r),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBox(width: 140.w, height: 18.h),
                  verticalSpace(8),
                  _buildBox(width: 180.w, height: 12.h),
                ],
              ),
            ),
            if (showArrow) ...[
              horizontalSpace(8),
              _buildBox(width: 12.w, height: 18.h, radius: 4.r),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.sageGray,
      highlightColor: ColorPalette.fogWhite,
      direction: ShimmerDirection.rtl,
      period: const Duration(milliseconds: 1300),
      child: child,
    );
  }

  Widget _buildBox({
    required double width,
    required double height,
    double? radius,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(radius ?? 6.r),
        ),
      ),
    );
  }
}
