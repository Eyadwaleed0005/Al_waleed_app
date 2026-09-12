import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/notifications/data/data_sources/error_handler/notification_error_handler.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/local_notification_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/notification_topic_local_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/remote/notification_remote_data_source.dart';
import 'package:al_waleed/features/notifications/data/models/app_notification_model.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:al_waleed/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final LocalNotificationDataSource _localNotificationDataSource;
  final NotificationTopicLocalDataSource _topicLocalDataSource;

  const NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required LocalNotificationDataSource localNotificationDataSource,
    required NotificationTopicLocalDataSource topicLocalDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localNotificationDataSource = localNotificationDataSource,
       _topicLocalDataSource = topicLocalDataSource;

  @override
  Future<Either<AppErrorModel, void>> initialize() async {
    try {
      await _localNotificationDataSource.initialize();
      await _remoteDataSource.requestPermission();

      return const Right(null);
    } catch (error) {
      return Left(NotificationErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, void>> syncGradeTopic({
    required String gradeId,
  }) async {
    final normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      return Left(NotificationErrorHandler.invalidGradeId());
    }

    try {
      final storedGradeId = (await _topicLocalDataSource.getSubscribedGradeId())
          ?.trim();

      if (storedGradeId == normalizedGradeId) {
        return const Right(null);
      }

      await _remoteDataSource.subscribeToGradeTopic(gradeId: normalizedGradeId);

      if (storedGradeId != null && storedGradeId.isNotEmpty) {
        try {
          await _remoteDataSource.unsubscribeFromGradeTopic(
            gradeId: storedGradeId,
          );
        } catch (error, stackTrace) {
          await _tryUnsubscribeFromGrade(gradeId: normalizedGradeId);

          Error.throwWithStackTrace(error, stackTrace);
        }
      }

      await _topicLocalDataSource.saveSubscribedGradeId(
        gradeId: normalizedGradeId,
      );

      return const Right(null);
    } catch (error) {
      return Left(NotificationErrorHandler.handle(error));
    }
  }

  @override
  Stream<Either<AppErrorModel, AppNotificationEntity>>
  streamForegroundNotifications() async* {
    try {
      final notificationStream = _remoteDataSource
          .streamForegroundNotifications();

      await for (final notification in notificationStream) {
        yield Right(notification.toEntity());
      }
    } catch (error) {
      yield Left(NotificationErrorHandler.handle(error));
    }
  }

  @override
  Stream<Either<AppErrorModel, AppNotificationEntity>>
  streamOpenedNotifications() {
    return _mergeOpenedNotificationStreams();
  }

  @override
  Future<Either<AppErrorModel, AppNotificationEntity?>>
  getInitialNotification() async {
    try {
      final localNotification = await _localNotificationDataSource
          .getInitialNotification();

      if (localNotification != null) {
        return Right(localNotification.toEntity());
      }

      final remoteNotification = await _remoteDataSource
          .getInitialNotification();

      return Right(remoteNotification?.toEntity());
    } catch (error) {
      return Left(NotificationErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, void>> showLocalNotification({
    required AppNotificationEntity notification,
  }) async {
    try {
      final notificationModel = AppNotificationModel.fromEntity(notification);

      await _localNotificationDataSource.showNotification(
        notification: notificationModel,
      );

      return const Right(null);
    } catch (error) {
      return Left(NotificationErrorHandler.handle(error));
    }
  }

  Stream<Either<AppErrorModel, AppNotificationEntity>>
  _mergeOpenedNotificationStreams() {
    late final StreamController<Either<AppErrorModel, AppNotificationEntity>>
    controller;

    StreamSubscription<AppNotificationModel>? remoteSubscription;
    StreamSubscription<AppNotificationModel>? localSubscription;

    bool isRemoteStreamDone = false;
    bool isLocalStreamDone = false;

    void closeControllerIfDone() {
      final areStreamsDone = isRemoteStreamDone && isLocalStreamDone;

      if (areStreamsDone && !controller.isClosed) {
        unawaited(controller.close());
      }
    }

    controller = StreamController<Either<AppErrorModel, AppNotificationEntity>>(
      onListen: () {
        remoteSubscription = _remoteDataSource
            .streamOpenedNotifications()
            .listen(
              (notification) {
                if (controller.isClosed) {
                  return;
                }

                controller.add(Right(notification.toEntity()));
              },
              onError: (Object error) {
                if (controller.isClosed) {
                  return;
                }

                controller.add(Left(NotificationErrorHandler.handle(error)));
              },
              onDone: () {
                isRemoteStreamDone = true;
                closeControllerIfDone();
              },
            );

        localSubscription = _localNotificationDataSource
            .streamOpenedNotifications()
            .listen(
              (notification) {
                if (controller.isClosed) {
                  return;
                }

                controller.add(Right(notification.toEntity()));
              },
              onError: (Object error) {
                if (controller.isClosed) {
                  return;
                }

                controller.add(Left(NotificationErrorHandler.handle(error)));
              },
              onDone: () {
                isLocalStreamDone = true;
                closeControllerIfDone();
              },
            );
      },
      onCancel: () async {
        await remoteSubscription?.cancel();
        await localSubscription?.cancel();

        remoteSubscription = null;
        localSubscription = null;
      },
    );

    return controller.stream;
  }

  Future<void> _tryUnsubscribeFromGrade({required String gradeId}) async {
    try {
      await _remoteDataSource.unsubscribeFromGradeTopic(gradeId: gradeId);
    } catch (_) {
    }
  }

  @override
Future<Either<AppErrorModel, void>>
unsubscribeFromCurrentGradeTopic() async {
  try {
    final storedGradeId =
        (await _topicLocalDataSource.getSubscribedGradeId())?.trim();

    if (storedGradeId == null || storedGradeId.isEmpty) {
      return const Right(null);
    }

    await _remoteDataSource.unsubscribeFromGradeTopic(
      gradeId: storedGradeId,
    );

    await _topicLocalDataSource.clearSubscribedGradeId();

    return const Right(null);
  } catch (error) {
    return Left(
      NotificationErrorHandler.handle(error),
    );
  }
}
}
