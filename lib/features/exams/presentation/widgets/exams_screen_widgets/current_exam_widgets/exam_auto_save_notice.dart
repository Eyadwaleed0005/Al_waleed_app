import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamAutoSaveNotice extends StatelessWidget {
  const ExamAutoSaveNotice({
    super.key,
    this.title = 'تُحفظ إجاباتك تلقائيًا أثناء الحل',
    this.subtitle = 'تأكد من اتصال الإنترنت قبل بدء المحاولة.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            ColorPalette.oceanBlue.withValues(alpha: 0.15),
            ColorPalette.oceanBlue.withValues(alpha: 0.05),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Icon(
              Icons.verified_user_outlined,
              color: ColorPalette.oceanBlue,
              size: 26.sp,
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.font12TextPrimaryBoldTajawal(),
                  ),
                  verticalSpace(2),
                  Text(
                    subtitle,
                    style: AppTextStyle.font11TextSecondaryRegularTajawal(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
