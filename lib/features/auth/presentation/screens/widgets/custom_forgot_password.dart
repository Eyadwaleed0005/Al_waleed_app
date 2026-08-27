
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomForgotpassword extends StatelessWidget {
  const CustomForgotpassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '.نسيت كلمة المرور؟ تواصل مع المدرس',
            style:
                AppTextStyle.font13TextSecondaryRegularTajawal(),
          ),
          SizedBox(width: 7.w),
          CircleAvatar(
            radius: 12.r,
            backgroundColor: ColorPalette.accent,
            child: Text(
              '؟',
              style:
                  AppTextStyle.font14TextPrimaryMediumKufam(),
            ),
          ),
        ],
      ),
    );
  }
}