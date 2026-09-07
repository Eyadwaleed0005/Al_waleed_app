import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_background.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_card/live_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionScreenContent extends StatelessWidget {
  const LiveSessionScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: LiveSessionBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomAppBar(
                  title: 'البث المباشر',
                  backgroundColor: Colors.transparent,
                  showBackButton: true,
                ),
                verticalSpace(24),
                Text(
                  'حصة مباشرة لصفك',
                  style: AppTextStyle.font13TextOceanBlueBoldTajawal(),
                ),
                verticalSpace(4),
                Text(
                  'افتح الرابط أو انسخه للانضمام إلى الحصة',
                  style: AppTextStyle.font13TextSecondaryRegularTajawal(),
                ),
                verticalSpace(24),
                const LiveSessionCard(),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}