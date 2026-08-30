import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReaderHeader extends StatelessWidget {
  const ReaderHeader({
    super.key,
    this.title = 'قارئ المذكرة',
    this.subject = 'الكيمياء العضوية',
  });

  final String title;
  final String subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.surface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorPalette.textPrimary,
                size: 20.sp,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyle.font18TextPrimarySemiBoldKufam().copyWith(
                    color: ColorPalette.primary,
                    fontWeight: FontWeightHelper.bold,
                  ),
                ),
                verticalSpace(2),
                Text(
                  subject,
                  style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                    color: ColorPalette.textSecondary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.description_outlined,
              color: ColorPalette.textOceanBlue,
              size: 28.sp,
            ),
          ],
        ),
      ),
    );
  }
}
