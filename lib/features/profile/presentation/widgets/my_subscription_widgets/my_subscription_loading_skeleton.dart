import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MySubscriptionLoadingSkeleton extends StatelessWidget {
  const MySubscriptionLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCard(
          child: Column(
            children: [
              _buildBox(width: 144.r, height: 144.r, radius: 72.r),
              verticalSpace(24),
              _buildBox(width: 110.w, height: 28.h, radius: 30.r),
              verticalSpace(16),
              _buildBox(width: 180.w, height: 24.h),
              verticalSpace(16),
              _buildBox(height: 14.h),
              verticalSpace(8),
              _buildBox(width: 190.w, height: 14.h),
            ],
          ),
        ),
        verticalSpace(24),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(width: 130.w, height: 20.h),
              ),
              verticalSpace(24),
              Center(
                child: _buildBox(width: 28.r, height: 28.r),
              ),
              verticalSpace(14),
              Center(
                child: _buildBox(width: 70.w, height: 40.h),
              ),
              verticalSpace(12),
              Center(
                child: _buildBox(width: 160.w, height: 14.h),
              ),
              verticalSpace(32),
              _buildDateRow(),
              verticalSpace(24),
              _buildDateRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Shimmer.fromColors(
        baseColor: ColorPalette.sageGray,
        highlightColor: ColorPalette.fogWhite,
        direction: ShimmerDirection.rtl,
        period: const Duration(milliseconds: 1300),
        child: child,
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        _buildBox(width: 40.r, height: 40.r, radius: 12.r),
        horizontalSpace(12),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _buildBox(width: 90.w, height: 14.h),
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildBox(width: 95.w, height: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildBox({double? width, required double height, double? radius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(radius ?? 6.r),
      ),
    );
  }
}
