import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Data model for navigation bar tabs.
class BottomNavItemData {
  const BottomNavItemData({required this.label, required this.iconPath});

  final String label;
  final String iconPath;
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, this.currentIndex, this.onItemSelected});

  final int? currentIndex;
  final ValueChanged<int>? onItemSelected;

  static List<BottomNavItemData> get items => [
    BottomNavItemData(label: 'حسابي', iconPath: AppImage().profile),
    BottomNavItemData(label: 'الامتحان', iconPath: AppImage().exam),
    BottomNavItemData(label: 'المذكرات', iconPath: AppImage().studyNotes),
    BottomNavItemData(label: 'الدروس', iconPath: AppImage().bookOpen),
    BottomNavItemData(label: 'الرئيسية', iconPath: AppImage().homeIcon),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = currentIndex ?? context.watch<BottomNavigationCubit>().state;
    void handleTap(int index) {
      if (onItemSelected != null) {
        onItemSelected!(index);
      } else {
        context.read<BottomNavigationCubit>().changeIndex(index);
      }
    }

    final double barHeight = 74.h;
    final double circleSize = 64.w;
    final double circleTopOffset = -22.h;

    return AppAnimations.bottomNavBarEntrance(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double totalWidth = constraints.maxWidth;
                final double tabWidth = totalWidth / items.length;

                // Dynamically compute left position for selected indicator circle in RTL
                final double indicatorLeft = (items.length - 1 - activeIndex) * tabWidth + (tabWidth - circleSize) / 2;

                return SizedBox(
                  height: barHeight + 2.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ── 1. Floating Primary Navigation Bar Container ───────
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: barHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(color: ColorPalette.accent.withValues(alpha: 0.7), width: 1.5.w),
                            boxShadow: [
                              BoxShadow(color: ColorPalette.primary.withValues(alpha: 0.45), blurRadius: 20.r, offset: Offset(0, 8.h)),
                            ],
                          ),
                        ),
                      ),

                      // ── 2. Reusable Animated Selected Circle Indicator ──────
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: indicatorLeft,
                        top: circleTopOffset,
                        child: _SelectedCircleIndicator(iconPath: items[activeIndex].iconPath, size: circleSize),
                      ),

                      // ── 3. Row of Navigation Items ──────────────────────────
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: barHeight,
                        child: Row(
                          children: List.generate(items.length, (index) {
                            final isSelected = activeIndex == index;
                            final item = items[index];

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => handleTap(index),
                                behavior: HitTestBehavior.opaque,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 28.h,
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 200),
                                        opacity: isSelected ? 0.0 : 1.0,
                                        child: ColorFiltered(
                                          colorFilter: const ColorFilter.mode(ColorPalette.accent, BlendMode.srcIn),
                                          child: Image.asset(item.iconPath, width: 26.w, height: 26.w),
                                        ),
                                      ),
                                    ),
                                    verticalSpace(4),
                                    Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.font12TextSecondaryMediumTajawal().copyWith(
                                        color: isSelected ? ColorPalette.highlight : ColorPalette.accent,
                                        fontWeight: isSelected ? FontWeightHelper.bold : FontWeightHelper.regular,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// The double-ringed elevated circular indicator shown for the selected tab.
class _SelectedCircleIndicator extends StatelessWidget {
  const _SelectedCircleIndicator({required this.iconPath, required this.size});

  final String iconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorPalette.accent, width: 2.w),
        boxShadow: [BoxShadow(color: ColorPalette.accent.withValues(alpha: 0.35), blurRadius: 18.r, spreadRadius: 2.r)],
      ),
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorPalette.highlight, width: 2.5.w),
        ),
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorPalette.accent),
          child: Center(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(ColorPalette.primary, BlendMode.srcIn),
              child: Image.asset(iconPath, width: 30.w, height: 30.w, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
