import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZoomToolbar extends StatelessWidget {
  const ZoomToolbar({
    super.key,
    required this.zoomPercent,
    required this.currentPage,
    required this.totalPages,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  final int zoomPercent;
  final int currentPage;
  final int totalPages;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: ColorPalette.primary.withValues(alpha: 0.15),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.10),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ZoomButton(icon: Icons.remove_rounded, onTap: onZoomOut),
          Text(
            '$zoomPercent%',
            style: AppTextStyle.font15TextPrimaryMediumTajawal().copyWith(
              fontWeight: FontWeightHelper.bold,
              color: ColorPalette.textPrimary,
            ),
          ),
          ZoomButton(icon: Icons.add_rounded, onTap: onZoomIn),
          Container(
            width: 1.w,
            height: 20.h,
            color: ColorPalette.border,
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '$currentPage / $totalPages',
              style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
                color: ColorPalette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ZoomButton extends StatelessWidget {
  const ZoomButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.primarySoftBackground,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(
            icon,
            color: ColorPalette.primary,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
