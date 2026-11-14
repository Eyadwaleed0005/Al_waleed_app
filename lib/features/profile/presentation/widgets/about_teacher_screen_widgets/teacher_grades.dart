import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherGrades extends StatelessWidget {
  const TeacherGrades({super.key, required this.gradeNames});

  final List<String> gradeNames;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 10.h,
        children: [
          for (final gradeName in gradeNames)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: ColorPalette.primarySoftBackground,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                gradeName,
                style: AppTextStyle.font14TextSecondaryRegularTajawal()
                    .copyWith(color: ColorPalette.primary),
              ),
            ),
        ],
      ),
    );
  }
}
