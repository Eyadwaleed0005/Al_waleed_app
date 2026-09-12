import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/get_initial_notification_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/initialize_notifications_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/show_local_notification_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/stream_foreground_notifications_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/stream_opened_notifications_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/sync_notification_grade_topic_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/unsubscribe_notification_grade_topic_use_case.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final InitializeNotificationsUseCase _initializeNotificationsUseCase;

  final SyncNotificationGradeTopicUseCase _syncNotificationGradeTopicUseCase;

  final UnsubscribeNotificationGradeTopicUseCase
  _unsubscribeNotificationGradeTopicUseCase;

  final StreamForegroundNotificationsUseCase
  _streamForegroundNotificationsUseCase;

  final StreamOpenedNotificationsUseCase _streamOpenedNotificationsUseCase;

  final GetInitialNotificationUseCase _getInitialNotificationUseCase;

  final ShowLocalNotificationUseCase _showLocalNotificationUseCase;

  NotificationCubit({
    required InitializeNotificationsUseCase initializeNotificationsUseCase,
    required SyncNotificationGradeTopicUseCase
    syncNotificationGradeTopicUseCase,
    required UnsubscribeNotificationGradeTopicUseCase
    unsubscribeNotificationGradeTopicUseCase,
    required StreamForegroundNotificationsUseCase
    streamForegroundNotificationsUseCase,
    required StreamOpenedNotificationsUseCase streamOpenedNotificationsUseCase,
    required GetInitialNotificationUseCase getInitialNotificationUseCase,
    required ShowLocalNotificationUseCase showLocalNotificationUseCase,
  }) : _initializeNotificationsUseCase = initializeNotificationsUseCase,
       _syncNotificationGradeTopicUseCase = syncNotificationGradeTopicUseCase,
       _unsubscribeNotificationGradeTopicUseCase =
           unsubscribeNotificationGradeTopicUseCase,
       _streamForegroundNotificationsUseCase =
           streamForegroundNotificationsUseCase,
       _streamOpenedNotificationsUseCase = streamOpenedNotificationsUseCase,
       _getInitialNotificationUseCase = getInitialNotificationUseCase,
       _showLocalNotificationUseCase = showLocalNotificationUseCase,
       super(const NotificationInitial());

  StreamSubscription<Either<AppErrorModel, AppNotificationEntity>>?
  _foregroundSubscription;

  StreamSubscription<Either<AppErrorModel, AppNotificationEntity>>?
  _openedSubscription;

  bool _isInitializing = false;
  bool _isInitialized = false;
  bool _isUnsubscribing = false;

  bool get _canEmit => !isClosed;

  Future<void> initialize() async {
    if (_isInitializing || _isInitialized || !_canEmit) {
      return;
    }

    _isInitializing = true;

    emit(const NotificationLoading());

    try {
      final result = await _initializeNotificationsUseCase();

      if (!_canEmit) {
        return;
      }

      await result.fold(
        (error) async {
          if (_canEmit) {
            emit(NotificationFailure(error: error));
          }
        },
        (_) async {
          _isInitialized = true;

          _listenToForegroundNotifications();
          _listenToOpenedNotifications();

          if (_canEmit) {
            emit(const NotificationReady());
          }

          await _handleInitialNotification();
        },
      );
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> syncGradeTopic({required String gradeId}) async {
    if (!_canEmit || _isUnsubscribing) {
      return;
    }

    final result = await _syncNotificationGradeTopicUseCase(gradeId: gradeId);

    if (!_canEmit) {
      return;
    }

    result.fold(
      (error) {
        emit(NotificationFailure(error: error));
      },
      (_) {
        if (state is NotificationFailure ||
            state is NotificationInitial ||
            state is NotificationLoading) {
          emit(const NotificationReady());
        }
      },
    );
  }

  Future<bool> unsubscribeFromCurrentGradeTopic() async {
    if (_isUnsubscribing || !_canEmit) {
      return false;
    }

    _isUnsubscribing = true;

    try {
      final result = await _unsubscribeNotificationGradeTopicUseCase();

      if (!_canEmit) {
        return false;
      }

      return await result.fold((error) {
        emit(NotificationFailure(error: error));
        return false;
      }, (_) => true);
    } finally {
      _isUnsubscribing = false;
    }
  }

  void navigationHandled() {
    if (!_canEmit) {
      return;
    }

    if (state is NotificationNavigationRequested) {
      emit(const NotificationReady());
    }
  }

  void _listenToForegroundNotifications() {
    unawaited(_foregroundSubscription?.cancel());

    _foregroundSubscription = _streamForegroundNotificationsUseCase().listen(
      _handleForegroundResult,
    );
  }

  void _listenToOpenedNotifications() {
    unawaited(_openedSubscription?.cancel());

    _openedSubscription = _streamOpenedNotificationsUseCase().listen(
      _handleOpenedResult,
    );
  }

  Future<void> _handleForegroundResult(
    Either<AppErrorModel, AppNotificationEntity> result,
  ) async {
    await result.fold(
      (error) async {
        if (_canEmit) {
          emit(NotificationFailure(error: error));
        }
      },
      (notification) async {
        final showResult = await _showLocalNotificationUseCase(
          notification: notification,
        );

        if (!_canEmit) {
          return;
        }

        showResult.fold((error) {
          emit(NotificationFailure(error: error));
        }, (_) {});
      },
    );
  }

  void _handleOpenedResult(
    Either<AppErrorModel, AppNotificationEntity> result,
  ) {
    if (!_canEmit) {
      return;
    }

    result.fold((error) {
      emit(NotificationFailure(error: error));
    }, _requestNavigation);
  }

  Future<void> _handleInitialNotification() async {
    final result = await _getInitialNotificationUseCase();

    if (!_canEmit) {
      return;
    }

    result.fold(
      (error) {
        emit(NotificationFailure(error: error));
      },
      (notification) {
        if (notification != null) {
          _requestNavigation(notification);
        }
      },
    );
  }

  void _requestNavigation(AppNotificationEntity notification) {
    if (!_canEmit || !notification.canNavigate) {
      return;
    }

    emit(NotificationNavigationRequested(notification: notification));
  }

  @override
  Future<void> close() async {
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();

    _foregroundSubscription = null;
    _openedSubscription = null;

    return super.close();
  }
}
