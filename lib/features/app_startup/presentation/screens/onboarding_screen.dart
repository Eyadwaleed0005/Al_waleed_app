import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/onboarding_cubit.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: const Scaffold(
          backgroundColor: ColorPalette.background,
          body: OnboardingScreenContent(),
        ),
      ),
    );
  }
}
