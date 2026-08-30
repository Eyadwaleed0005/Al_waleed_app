import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/live_session_background.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/no_live_badge_header.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/no_live_session_notice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoLiveSessionWidget extends StatelessWidget {
  const NoLiveSessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveSessionBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            verticalSpace(50.h),
            Expanded(
              child: Column(
                children: [
                  NoLiveBadgeHeader(),
                  verticalSpace(26.h),

                  Text(
                    'لا توجد حصة مباشرة الآن',
                    style: AppTextStyle.font20TextBlackSemiBoldKufam(),
                  ),
                  verticalSpace(30.h),
                  Text(
                    'سيظهر رابط الحصة هنا فور إضافته من المدرس',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                  ),
                  verticalSpace(40.h),

                  NoSessionNoticeCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

