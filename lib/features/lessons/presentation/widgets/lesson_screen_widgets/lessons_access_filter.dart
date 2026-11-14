import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsAccessFilter extends StatelessWidget {
  const LessonsAccessFilter({
    super.key,
    required this.showFree,
    required this.onChanged,
  });

  final bool showFree;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: ColorPalette.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildOption(
              title: 'مجانية',
              isSelected: showFree,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _buildOption(
              title: 'مدفوعة',
              isSelected: !showFree,
              onTap: () => onChanged(false),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.darkForestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isSelected ? null : onTap,
            child: Center(
              child: Text(
                title,
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
