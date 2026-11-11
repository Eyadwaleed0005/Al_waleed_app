import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/onboarding_cubit.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/onboarding_state.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_bottom_section.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_data.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_header.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_illustration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreenContent extends StatelessWidget {
  const OnboardingScreenContent({super.key});

  void _openLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouteNames.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status == OnboardingStatus.completed) {
          _openLogin(context);
        } else if (state.status == OnboardingStatus.failure) {
          showAppToast(
            context,
            message: 'تعذر حفظ إكمال المقدمة، حاول مرة أخرى',
            icon: Icons.error_outline_rounded,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final text = onboardingTexts[state.currentIndex];
        final isBusy =
            state.status == OnboardingStatus.saving ||
            state.status == OnboardingStatus.completed;

        return AbsorbPointer(
          absorbing: isBusy,
          child: ColoredBox(
            color: ColorPalette.background,
            child: SafeArea(
              bottom: false,
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 19.h,
                      ),
                      child: OnboardingHeader(
                        logoAsset: AppImage().logoApp,
                        onSkip: cubit.completeOnboarding,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        child: Center(
                          child: OnboardingIllustration(
                            image: onboardingImages[state.currentIndex],
                          ),
                        ),
                      ),
                    ),
                    OnboardingBottomSection(
                      subtitle: text.subtitle,
                      title: text.title,
                      description: text.description,
                      currentIndex: state.currentIndex,
                      pageCount: cubit.pageCount,
                      onNext: cubit.nextPage,
                      onBack: cubit.previousPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
