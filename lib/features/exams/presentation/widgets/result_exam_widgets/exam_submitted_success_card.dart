import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamSubmittedSuccessCard extends StatelessWidget {
  const ExamSubmittedSuccessCard({
    super.key,
    required this.examName,
    this.title = 'تم تسليم الاختبار بنجاح',
    this.noticeText = 'تم تصحيح إجاباتك وحفظ النتيجة بنجاح.',
  });

  final String examName;
  final String title;
  final String noticeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: ColorPalette.emeraldGreen.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorPalette.emeraldGreen,
                width: 2.2.w,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check_rounded,
              size: 40.sp,
              color: ColorPalette.darkForestGreen,
            ),
          ),
          verticalSpace(18),
          Text(
            title,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font14TextPrimarySemiBoldKufam(),
          ),
          verticalSpace(8),
          Text(
            examName,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font12TextSecondaryMediumTajawal(),
          ),
          verticalSpace(22),
          Text(
            noticeText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font13TextPrimaryBoldTajawal(),
          ),
        ],
      ),
    );
  }
}
