import 'package:al_waleed/core/errors/error_model/app_error_model.dart';

enum OnboardingStatus { initial, saving, completed, failure }

class OnboardingState {
  const OnboardingState({
    this.currentIndex = 0,
    this.status = OnboardingStatus.initial,
    this.error,
  });

  final int currentIndex;
  final OnboardingStatus status;
  final AppErrorModel? error;
}
