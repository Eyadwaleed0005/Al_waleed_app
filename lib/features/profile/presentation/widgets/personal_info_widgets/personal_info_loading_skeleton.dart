import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PersonalInfoLoadingSkeleton extends StatelessWidget {
  const PersonalInfoLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppCard(
      child: _buildShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _buildBox(width: 130.w, height: 20.h),
            ),
            verticalSpace(24),
            _buildField(),
            verticalSpace(20),
            _buildField(),
            verticalSpace(20),
            _buildField(),
            verticalSpace(16),
            _buildBox(height: 62.h, radius: 12.r),
          ],
        ),
      ),
    );
  }

  Widget _buildField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: _buildBox(width: 90.w, height: 14.h),
        ),
        verticalSpace(8),
        _buildBox(height: 56.h, radius: 18.r),
      ],
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
