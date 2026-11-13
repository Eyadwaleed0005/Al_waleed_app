import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageAsset,
  });

  final String name;
  final String email;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorPalette.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          ClipOval(
            child: SvgPicture.asset(
              imageAsset,
              width: 88.w,
              height: 88.h,
              fit: BoxFit.contain,
            ),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTextStyle.font20TextBlackSemiBoldKufam().copyWith(
                    color: ColorPalette.textLight,
                  ),
                ),
                verticalSpace(8),
                Text(
                  email,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: AppTextStyle.font14TextSecondaryRegularTajawal()
                      .copyWith(color: ColorPalette.paleSage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
