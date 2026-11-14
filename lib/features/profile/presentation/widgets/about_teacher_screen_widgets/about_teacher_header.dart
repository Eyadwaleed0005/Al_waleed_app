import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutTeacherHeader extends StatelessWidget {
  const AboutTeacherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Image.asset(
            AppImage().aboutTeacherImage,
            width: double.infinity,
            height: 300.h,
            fit: BoxFit.contain,
          ),
        ),
        verticalSpace(20),
        Text(
          'مستر وليد أبو العنين',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font20TextPrimarySemiBoldKufam().copyWith(
            color: ColorPalette.primary,
          ),
        ),
        verticalSpace(8),
        Text(
          'مدرّس أول كيمياء',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font14TextSecondaryRegularTajawal(),
        ),
        verticalSpace(14),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorPalette.highlight,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              '٣٠ عامًا من الخبرة',
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font14TextPrimarySemiBoldKufam().copyWith(
                color: ColorPalette.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
