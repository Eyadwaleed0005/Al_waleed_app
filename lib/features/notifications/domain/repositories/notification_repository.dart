import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class NotificationRepository {
  Future<Either<AppErrorModel, void>> initialize();

  Future<Either<AppErrorModel, void>> syncGradeTopic({
    required String gradeId,
  });

  Future<Either<AppErrorModel, void>>
  unsubscribeFromCurrentGradeTopic();

  Stream<Either<AppErrorModel, AppNotificationEntity>>
  streamForegroundNotifications();

  Stream<Either<AppErrorModel, AppNotificationEntity>>
  streamOpenedNotifications();

  Future<Either<AppErrorModel, AppNotificationEntity?>>
  getInitialNotification();

  Future<Either<AppErrorModel, void>> showLocalNotification({
    required AppNotificationEntity notification,
  });
}