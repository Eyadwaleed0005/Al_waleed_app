import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_card/live_session_badge_header.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_card/live_session_link.dart';
import 'package:flutter/material.dart';

class LiveSessionCard extends StatelessWidget {
  const LiveSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const LiveSessionBadgeHeader(),
          verticalSpace(16),
          Text(
            'رابط الحصة جاهز',
            style: AppTextStyle.font20TextBlackSemiBoldKufam(),
          ),
          verticalSpace(4),
          Text(
            'الصف الثالث الثانوي',
            style: AppTextStyle.font12TextSecondaryMediumTajawal(),
          ),
          verticalSpace(24),
          Text(
            'رابط الحصة',
            style: AppTextStyle.font12TextSecondaryMediumTajawal(),
          ),
          verticalSpace(8),
          const LiveSessionLink(),
          verticalSpace(8),
        ],
      ),
    );
  }
}