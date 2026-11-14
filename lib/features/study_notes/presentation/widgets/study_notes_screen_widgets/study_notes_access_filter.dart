import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesAccessFilter extends StatelessWidget {
  const StudyNotesAccessFilter({
    super.key,
    required this.showFree,
    required this.onChanged,
  });

  final bool showFree;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: _buildOption(
              title: 'مجانية',
              isSelected: showFree,
              onTap: () {
                if (!showFree) {
                  onChanged(true);
                }
              },
            ),
          ),
          Expanded(
            child: _buildOption(
              title: 'مدفوعة',
              isSelected: !showFree,
              onTap: () {
                if (showFree) {
                  onChanged(false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      excludeSemantics: true,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(14.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
              child: Text(
                title,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font14TextPrimarySemiBoldKufam().copyWith(
                  color: isSelected
                      ? ColorPalette.textLight
                      : ColorPalette.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
