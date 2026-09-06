import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/no_live_session_widget/no_live_session_notice_card.dart';
import 'package:flutter/material.dart';

class NoLiveSessionWidget extends StatelessWidget {
  const NoLiveSessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAnimations.emptyStateEntrance(
      child: AppEmptyState(
        title: 'لا توجد حصة مباشرة الآن',
        subtitle: 'سيظهر رابط الحصة هنا فور إضافته من المدرس',
        icon: Icons.video_call_outlined,
        iconContainerSize: 130,
        iconSize: 60,
        iconColor: ColorPalette.secondary,
        iconBackgroundColor: ColorPalette.secondary.withValues(alpha: 0.06),
        iconTitleSpacing: 26,
        titleSubtitleSpacing: 30,
        footerSpacing: 40,
        footer: const NoSessionNoticeCard(),
      ),
    );
  }
}