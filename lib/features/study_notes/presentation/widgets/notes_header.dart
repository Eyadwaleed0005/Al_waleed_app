import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A full-bleed white header card with rounded bottom corners, used at the
/// top of the study notes list screen.
class NotesHeader extends StatelessWidget {
  const NotesHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        boxShadow: [BoxShadow(color: ColorPalette.primary.withValues(alpha: 0.08), blurRadius: 16.r, offset: Offset(0, 6.h))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.font20TextPrimarySemiBoldKufam().copyWith(fontSize: 24.sp),
          ),
        ),
      ),
    );
  }
}
