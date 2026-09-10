import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/live_session/presentation/cubits/live_session_cubit/live_session_cubit.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_card/live_session_badge_header.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_card/live_session_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionCard extends StatelessWidget {
  final String gradeId;

  const LiveSessionCard({super.key, required this.gradeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveSessionCubit, LiveSessionState>(
      builder: (context, state) {
        if (state is LiveSessionFailure) {
          return CustomAppCard(
            child: AppErrorState(
              message: state.errorMessage,
              onRetry: () => context.read<LiveSessionCubit>().getLiveSession(
                gradeId: gradeId,
              ),
            ),
          );
        }

        if (state is LiveSessionSuccess &&
            state.liveSessionEntity.meetingUrl.trim().isEmpty) {
          return const CustomAppCard(
            child: AppEmptyState(
              title: 'لا يوجد بث مباشر حاليًا',
              subtitle: 'ارجع في موعد الحصة المعلن',
              icon: Icons.videocam_off_rounded,
            ),
          );
        }

        final bool isLoading = state is LiveSessionLoading;
        final session = state is LiveSessionSuccess
            ? state.liveSessionEntity
            : null;

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
                gradeId,
                style: AppTextStyle.font12TextSecondaryMediumTajawal(),
              ),
              verticalSpace(24),
              Text(
                'رابط الحصة',
                style: AppTextStyle.font12TextSecondaryMediumTajawal(),
              ),
              verticalSpace(8),
              LiveSessionLink(
                sessionLink: session?.meetingUrl ?? '',
                isLoading: isLoading,
              ),
              verticalSpace(8),
            ],
          ),
        );
      },
    );
  }
}
