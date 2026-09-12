import 'package:al_waleed/features/notifications/data/models/app_notification_model.dart';

abstract interface class LocalNotificationDataSource {
  Future<void> initialize();

  Future<void> showNotification({
    required AppNotificationModel notification,
  });

  Stream<AppNotificationModel> streamOpenedNotifications();

  Future<AppNotificationModel?> getInitialNotification();
}