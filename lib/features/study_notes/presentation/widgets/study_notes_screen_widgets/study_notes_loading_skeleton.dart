import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StudyNotesLoadingSkeleton extends StatelessWidget {
  const StudyNotesLoadingSkeleton({super.key});

  static const Color _cardColor = Color(0xFFF5F5F5);
  static const Color _baseColor = Color(0xFFE0E0E0);
  static const Color _highlightColor = Color(0xFFF0F0F0);
  static const Color _borderColor = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
      itemCount: 3,
      separatorBuilder: (_, _) => verticalSpace(14),
      itemBuilder: (_, _) => _buildCardSkeleton(),
    );
  }

  Widget _buildCardSkeleton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: _borderColor),
        ),
        child: Shimmer.fromColors(
          baseColor: _baseColor,
          highlightColor: _highlightColor,
          direction: ShimmerDirection.rtl,
          period: const Duration(milliseconds: 1300),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBox(height: 180.h, radius: 0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 23.w, 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildBox(width: 210.w, height: 22.h),
                        ),
                        verticalSpace(12),
                        _buildBox(height: 14.h),
                        verticalSpace(8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildBox(width: 180.w, height: 14.h),
                        ),
                        verticalSpace(12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildBox(width: 150.w, height: 11.h),
                        ),
                        verticalSpace(18),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: _buildBox(width: 100.w, height: 16.h),
                              ),
                            ),
                            horizontalSpace(12),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _buildBox(
                                  width: 120.w,
                                  height: 38.h,
                                  radius: 10.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 5.w,
                child: const ColoredBox(color: ColorPalette.surface),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox({double? width, required double height, double? radius}) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(radius ?? 6.r),
        ),
      ),
    );
  }
}
