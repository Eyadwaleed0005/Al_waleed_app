import 'package:al_waleed/features/app_startup/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required this.pageCount,
    required CompleteOnboardingUseCase completeOnboardingUseCase,
  }) : assert(pageCount > 0),
       _completeOnboardingUseCase = completeOnboardingUseCase,
       super(const OnboardingState());

  final int pageCount;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  bool get isLastPage => state.currentIndex == pageCount - 1;

  bool get _isBlocked =>
      isClosed ||
      state.status == OnboardingStatus.saving ||
      state.status == OnboardingStatus.completed;

  Future<void> nextPage() async {
    if (_isBlocked) return;

    if (isLastPage) {
      await completeOnboarding();
      return;
    }

    emit(OnboardingState(currentIndex: state.currentIndex + 1));
  }

  void previousPage() {
    if (_isBlocked || state.currentIndex == 0) return;

    emit(OnboardingState(currentIndex: state.currentIndex - 1));
  }

  Future<void> completeOnboarding() async {
    if (_isBlocked) return;

    emit(
      OnboardingState(
        currentIndex: state.currentIndex,
        status: OnboardingStatus.saving,
      ),
    );

    final result = await _completeOnboardingUseCase();

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          OnboardingState(
            currentIndex: state.currentIndex,
            status: OnboardingStatus.failure,
            error: error,
          ),
        );
      },
      (_) {
        emit(
          OnboardingState(
            currentIndex: state.currentIndex,
            status: OnboardingStatus.completed,
          ),
        );
      },
    );
  }
}
