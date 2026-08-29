import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonReaderControls extends StatelessWidget {
  const LessonReaderControls({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 295.w,
    height: 55.h,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
      color: ColorPalette.surface,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: ColorPalette.border),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ControlButton(icon: Icons.remove, onPressed: () {}),
        Text('100%', style: AppTextStyle.font14TextPrimaryMediumKufam()),
        _ControlButton(icon: Icons.add, onPressed: () {}),
        VerticalDivider(
          color: ColorPalette.divider,
          width: 1.w,
          thickness: 1,
          indent: 14.h,
          endIndent: 14.h,
        ),
        Text(
          '1 / 8',
          style: AppTextStyle.font14TextPrimaryMediumKufam().copyWith(
            color: ColorPalette.textSecondary,
          ),
        ),
      ],
    ),
  );
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Container(
    width: 40.w,
    height: 40.w,
    decoration: BoxDecoration(
      color: ColorPalette.primarySoftBackground,
      borderRadius: BorderRadius.all(Radius.circular(12.r)),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: ColorPalette.primary, size: 22.sp),
    ),
  );
}
