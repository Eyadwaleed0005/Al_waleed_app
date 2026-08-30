import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/live_session_background.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/live_session_badge_header.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/live_session_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionScreenBody extends StatelessWidget {
  const LiveSessionScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveSessionBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'حصة مباشرة لصفك',
              style: AppTextStyle.font13TextOceanBlueBoldTajawal(),
            ),
            verticalSpace(4.h),
            Text(
              'افتح الرابط أو النسخه للانضمام إلى الحصة',
              style: AppTextStyle.font13TextSecondaryRegularTajawal(),
            ),
            verticalSpace(24.h),
            CustomAppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LiveSessionBadgeHeader(),
                  verticalSpace(16.h),
                  Text(
                    'رابط الحصة جاهز',
                    style: AppTextStyle.font20TextBlackSemiBoldKufam(),
                  ),
                  verticalSpace(4.h),
                  Text(
                    'الصف الثالث الثانوي',
                    style: AppTextStyle.font12TextSecondaryMediumTajawal(),
                  ),
                  verticalSpace(24.h),

                  Text(
                    'رابط الحصة',
                    style: AppTextStyle.font12TextSecondaryMediumTajawal(),
                  ),
                  verticalSpace(8.h),
                  LiveSessionLink(),
                  verticalSpace(8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
