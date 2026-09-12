import 'dart:async';

import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/features/app_startup/domain/entities/app_startup_destination.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/app_startup_state.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/splash_loading_view.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/splash_subscription_expired_dialog.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/splash_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartupCubit, AppStartupState>(
      listenWhen: (previous, current) {
        return current is AppStartupNavigateToLogin ||
            current is AppStartupNavigateToHome ||
            current is AppStartupUpdateRequired ||
            current is AppStartupSubscriptionExpired;
      },
      listener: _handleStartupState,
      child: const SplashLoadingView(),
    );
  }

  void _handleStartupState(BuildContext context, AppStartupState state) {
    switch (state) {
      case AppStartupNavigateToLogin():
        _navigateToLogin(context);

      case AppStartupNavigateToHome():
        _navigateToHome(context);

      case AppStartupUpdateRequired updateState:
        unawaited(
          _showUpdateDialog(
            context: context,
            destination: updateState.destination,
          ),
        );

      case AppStartupSubscriptionExpired():
        unawaited(_showSubscriptionExpiredDialog(context));

      case AppStartupInitial():
      case AppStartupLoading():
        break;
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.mainNavigationScreen,
      (route) => false,
    );
  }

  Future<void> _showUpdateDialog({
    required BuildContext context,
    required AppStartupUpdateDestination destination,
  }) async {
    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return SplashUpdateDialog(
          destination: destination,
          onUpdatePressed: () {
            unawaited(
              _openStore(
                context: context,
                storeUrl: destination.version.storeUrl,
              ),
            );
          },
          onContinuePressed: destination.isForced
              ? null
              : () {
                  Navigator.of(dialogContext).pop();

                  context
                      .read<AppStartupCubit>()
                      .continueWithoutOptionalUpdate();
                },
        );
      },
    );
  }

  Future<void> _showSubscriptionExpiredDialog(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return SplashSubscriptionExpiredDialog(
          onRetryPressed: () {
            Navigator.of(dialogContext).pop();

            context.read<AppStartupCubit>().retrySubscriptionCheck();
          },
          onCloseAppPressed: SystemNavigator.pop,
        );
      },
    );
  }

  Future<void> _openStore({
    required BuildContext context,
    required String storeUrl,
  }) async {
    final normalizedStoreUrl = storeUrl.trim();
    final uri = Uri.tryParse(normalizedStoreUrl);

    if (normalizedStoreUrl.isEmpty || uri == null || !uri.hasScheme) {
      _showStoreError(context);

      return;
    }

    try {
      final didOpenStore = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!didOpenStore && context.mounted) {
        _showStoreError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showStoreError(context);
      }
    }
  }

  void _showStoreError(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    showAppToast(
      context,
      message: 'تعذر فتح متجر التطبيقات',
      icon: Icons.error_outline_rounded,
    );
  }
}
