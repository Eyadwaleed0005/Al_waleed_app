import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/live_session/presentation/cubits/live_session_cubit/live_session_cubit.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_background.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_states/live_session_empty_view.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_states/live_session_error_view.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_states/live_session_loading_view.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_states/live_session_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionScreenContent extends StatelessWidget {
  final String gradeId;

  const LiveSessionScreenContent({super.key, required this.gradeId});

  @override
  Widget build(BuildContext context) {
    return LiveSessionBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: AppAnimations.screenSection(
                delay: 100,
                child: CustomAppBar(
                  title: 'البث المباشر',
                  backgroundColor: Colors.transparent,
                  showBackButton: true,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<LiveSessionCubit, LiveSessionState>(
                builder: (context, state) {
                  if (state is LiveSessionFailure) {
                    return LiveSessionErrorView(
                      errorMessage: state.errorMessage,
                      onRetry: () {
                        context.read<LiveSessionCubit>().getLiveSession(
                          gradeId: gradeId,
                        );
                      },
                    );
                  }

                  if (state is LiveSessionEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: const Center(child: LiveSessionEmptyView()),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppAnimations.screenSection(
                          delay: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'حصة مباشرة لصفك',
                                style:
                                    AppTextStyle.font13TextOceanBlueBoldTajawal(),
                              ),
                              verticalSpace(4),
                              Text(
                                'افتح الرابط أو انسخه للانضمام إلى الحصة',
                                style:
                                    AppTextStyle.font13TextSecondaryRegularTajawal(),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(24),
                        if (state is LiveSessionInitial ||
                            state is LiveSessionLoading)
                          AppAnimations.screenSection(
                            delay: 450,
                            child: const LiveSessionLoadingView(),
                          ),
                        if (state is LiveSessionSuccess)
                          AppAnimations.screenSection(
                            delay: 450,
                            child: LiveSessionSuccessView(
                              liveSession: state.liveSessionEntity,
                            ),
                          ),
                        verticalSpace(20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
