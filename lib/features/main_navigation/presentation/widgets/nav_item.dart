import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavItemData {
  const BottomNavItemData({required this.label, required this.iconPath});

  final String label;
  final String iconPath;
}

class NavItem extends StatelessWidget {
  const NavItem({super.key, required this.data, required this.isSelected, required this.onTap});

  final BottomNavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _iconSlotSize = 22;

  static const double _liftOffset = 20;

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? ColorPalette.highlight : ColorPalette.textLight.withValues(alpha: 0.55);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: ColorPalette.highlight.withValues(alpha: 0.18),
        highlightColor: ColorPalette.highlight.withValues(alpha: 0.10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _iconSlotSize.w,
              height: _iconSlotSize.w,
              child: OverflowBox(
                minWidth: 0,
                maxWidth: double.infinity,
                minHeight: 0,
                maxHeight: double.infinity,
                child: Transform.translate(
                  offset: isSelected ? Offset(0, -_liftOffset.h) : Offset.zero,
                  child: isSelected
                      ? _SelectedNavBadge(iconPath: data.iconPath)
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                          child: Image.asset(data.iconPath, width: _iconSlotSize.w, height: _iconSlotSize.w),
                        ),
                ),
              ),
            ),
            verticalSpace(4),
            Text(
              data.label,
              style: AppTextStyle.font11TextSecondaryRegularTajawal().copyWith(
                color: color,
                fontWeight: isSelected ? FontWeightHelper.bold : FontWeightHelper.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The circular badge shown for the selected tab: a small icon on a soft
/// green fill, wrapped in two concentric ring borders (accent, then
/// highlight), poking out above the bar.
class _SelectedNavBadge extends StatelessWidget {
  const _SelectedNavBadge({required this.iconPath});

  final String iconPath;

  static const double _size = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size.w,
      height: _size.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorPalette.accent, width: 2.5.w),
      ),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorPalette.highlight, width: 2.5.w),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorPalette.primarySoftBackground),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(ColorPalette.primary, BlendMode.srcIn),
            child: Image.asset(iconPath, width: 18.w, height: 18.w),
          ),
        ),
      ),
    );
  }
}
