import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamAnswerOptionTile extends StatelessWidget {
  const ExamAnswerOptionTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorPalette.oceanBlue.withValues(alpha: .1)
                  : ColorPalette.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? ColorPalette.oceanBlue
                    : ColorPalette.border,
                width: isSelected ? 1.5.w : 1.2.w,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  _buildRadioIndicator(),
                  horizontalSpace(12),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyle.font13TextPrimaryMediumTajawal()
                          .copyWith(
                            color: isSelected
                                ? ColorPalette.oceanBlue
                                : ColorPalette.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioIndicator() {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        color: isSelected ? ColorPalette.oceanBlue : ColorPalette.background,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? ColorPalette.oceanBlue : ColorPalette.disabled,
          width: isSelected ? 2.w : 1.5.w,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPalette.background,
                ),
              ),
            )
          : null,
    );
  }
}
