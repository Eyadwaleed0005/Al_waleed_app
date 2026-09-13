import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamSubmittedSuccessCard extends StatelessWidget {
  const ExamSubmittedSuccessCard({
    super.key,
    this.title = 'تم تسليم الاختبار بنجاح',
    this.examName = 'اختبار الكيمياء العضوية',
    this.noticeText = 'تم حفظ إجاباتك وإرسالها للمدرس للمراجعة.',
  });

  final String title;
  final String examName;
  final String noticeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
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
            width: 55.w,
            height: 55.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorPalette.emeraldGreen,
                width: 2.2.w,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.check_rounded,
                size: 38.sp,
                color: ColorPalette.darkForestGreen,
              ),
            ),
          ),
          verticalSpace(20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.font14TextPrimarySemiBoldKufam(),
          ),
          verticalSpace(6),
          Text(
            examName,
            textAlign: TextAlign.center,
            style: AppTextStyle.font12TextSecondaryMediumTajawal(),
          ),
          verticalSpace(75),
          Text(
            noticeText,
            textAlign: TextAlign.center,
            style: AppTextStyle.font13TextPrimaryBoldTajawal(),
          ),
        ],
      ),
    );
  }
}
