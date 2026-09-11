import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_type.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationNavigationHandler extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const NotificationNavigationHandler({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listenWhen: (previous, current) {
        return current is NotificationNavigationRequested;
      },
      listener: (context, state) {
        if (state is! NotificationNavigationRequested) {
          return;
        }

        _navigateFromNotification(context: context, state: state);
      },
      child: child,
    );
  }

  void _navigateFromNotification({
    required BuildContext context,
    required NotificationNavigationRequested state,
  }) {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    final notification = state.notification;

    switch (notification.type) {
      case AppNotificationType.lesson:
        _openMainNavigationTab(navigator: navigator, tabIndex: 3);
        break;

      case AppNotificationType.studyNote:
        _openMainNavigationTab(navigator: navigator, tabIndex: 1);
        break;

      case AppNotificationType.exam:
        _openMainNavigationTab(navigator: navigator, tabIndex: 4);
        break;

      case AppNotificationType.liveSession:
        if (notification.gradeId.trim().isNotEmpty) {
          navigator.pushNamed(
            RouteNames.liveSessionScreen,
            arguments: notification.gradeId.trim(),
          );
        }
        break;

      case AppNotificationType.unknown:
        break;
    }

    context.read<NotificationCubit>().navigationHandled();
  }

  void _openMainNavigationTab({
    required NavigatorState navigator,
    required int tabIndex,
  }) {
    navigator.pushNamedAndRemoveUntil(
      RouteNames.mainNavigationScreen,
      (route) => false,
      arguments: tabIndex,
    );
  }
}
