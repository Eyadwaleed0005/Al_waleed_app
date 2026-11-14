import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LessonsLoadingSkeleton extends StatelessWidget {
  const LessonsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < 3; index++) ...[
            _buildCardSkeleton(),
            if (index != 2) verticalSpace(22),
          ],
        ],
      ),
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: ColorPalette.sageGray,
        highlightColor: ColorPalette.fogWhite,
        direction: ShimmerDirection.rtl,
        period: const Duration(milliseconds: 1300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBox(height: 180.h, radius: 0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildBox(width: 210.w, height: 18.h),
                  ),
                  verticalSpace(10),
                  _buildBox(height: 12.h),
                  verticalSpace(6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildBox(width: 170.w, height: 12.h),
                  ),
                  verticalSpace(16),
                  _buildBox(height: 38.h, radius: 10.r),
                ],
              ),
            ),
          ],
        ),
      ),
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
