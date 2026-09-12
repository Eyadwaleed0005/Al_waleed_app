import 'package:al_waleed/features/app_startup/domain/entities/app_startup_destination.dart';
import 'package:al_waleed/features/app_startup/domain/use_cases/resolve_app_startup_destination_use_case.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/app_startup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit({required this._resolveAppStartupDestinationUseCase})
    : super(const AppStartupInitial());

  final ResolveAppStartupDestinationUseCase
  _resolveAppStartupDestinationUseCase;

  static const Duration _minimumSplashDuration = Duration(seconds: 4);

  bool _isResolving = false;
  bool _ignoreOptionalUpdate = false;

  Future<void> initialize() {
    _ignoreOptionalUpdate = false;

    return _resolveDestination(waitForMinimumDuration: true);
  }

  Future<void> continueWithoutOptionalUpdate() {
    _ignoreOptionalUpdate = true;

    return _resolveDestination(waitForMinimumDuration: false);
  }

  Future<void> retrySubscriptionCheck() {
    return _resolveDestination(waitForMinimumDuration: false);
  }

  Future<void> retry() {
    return retrySubscriptionCheck();
  }

  Future<void> _resolveDestination({
    required bool waitForMinimumDuration,
  }) async {
    if (_isResolving || isClosed) {
      return;
    }

    _isResolving = true;

    final startedAt = DateTime.now();

    try {
      emit(const AppStartupLoading());

      final destination = await _getDestinationSafely();

      if (waitForMinimumDuration) {
        await _waitForMinimumSplashDuration(startedAt: startedAt);
      }

      if (isClosed) {
        return;
      }

      _emitDestination(destination);
    } finally {
      _isResolving = false;
    }
  }

  Future<AppStartupDestination> _getDestinationSafely() async {
    try {
      return await _resolveAppStartupDestinationUseCase(
        ignoreOptionalUpdate: _ignoreOptionalUpdate,
      );
    } catch (_) {
      return const AppStartupLoginDestination();
    }
  }

  Future<void> _waitForMinimumSplashDuration({
    required DateTime startedAt,
  }) async {
    final elapsedDuration = DateTime.now().difference(startedAt);

    final remainingDuration = _minimumSplashDuration - elapsedDuration;

    if (remainingDuration > Duration.zero) {
      await Future<void>.delayed(remainingDuration);
    }
  }

  void _emitDestination(AppStartupDestination destination) {
    switch (destination) {
      case AppStartupLoginDestination():
        emit(const AppStartupNavigateToLogin());

      case AppStartupHomeDestination homeDestination:
        emit(AppStartupNavigateToHome(gradeId: homeDestination.gradeId));

      case AppStartupUpdateDestination updateDestination:
        emit(AppStartupUpdateRequired(destination: updateDestination));

      case AppStartupSubscriptionExpiredDestination expiredDestination:
        emit(AppStartupSubscriptionExpired(destination: expiredDestination));
    }
  }
}
