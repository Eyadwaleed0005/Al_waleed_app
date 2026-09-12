import 'dart:async';
import 'dart:ui';

import 'package:al_waleed/features/notifications/data/data_sources/local/local_notification_data_source.dart';
import 'package:al_waleed/features/notifications/data/models/app_notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotificationDataSource
    implements LocalNotificationDataSource {
  FlutterLocalNotificationDataSource({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
  }) : _localNotificationsPlugin = localNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  final StreamController<AppNotificationModel> _openedNotificationsController =
      StreamController<AppNotificationModel>.broadcast();

  static const String channelId = 'high_importance_channel_v2';

  static const String _notificationIcon = 'ic_notification';

  static const Color _notificationColor = Color(0xFF023A22);

  static const RawResourceAndroidNotificationSound _notificationSound =
      RawResourceAndroidNotificationSound('al_waleed_notification');

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        channelId,
        'إشعارات منصة الوليد',
        description: 'إشعارات الدروس والمذكرات والامتحانات والبث المباشر',
        importance: Importance.max,
        playSound: true,
        sound: _notificationSound,
        enableVibration: true,
      );

  @override
  Future<void> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings(_notificationIcon),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    final androidNotificationsPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidNotificationsPlugin?.createNotificationChannel(
      _androidChannel,
    );

    await androidNotificationsPlugin?.requestNotificationsPermission();
  }

  @override
  Future<void> showNotification({required AppNotificationModel notification}) {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'إشعارات منصة الوليد',
        channelDescription:
            'إشعارات الدروس والمذكرات والامتحانات والبث المباشر',
        icon: _notificationIcon,
        color: _notificationColor,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: _notificationSound,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    return _localNotificationsPlugin.show(
      id: notification.eventId.hashCode & 0x7fffffff,
      title: notification.title,
      body: notification.body,
      notificationDetails: notificationDetails,
      payload: notification.toPayload(),
    );
  }

  @override
  Stream<AppNotificationModel> streamOpenedNotifications() {
    return _openedNotificationsController.stream;
  }

  @override
  Future<AppNotificationModel?> getInitialNotification() async {
    final launchDetails = await _localNotificationsPlugin
        .getNotificationAppLaunchDetails();

    final didLaunchFromNotification =
        launchDetails?.didNotificationLaunchApp ?? false;

    final payload = launchDetails?.notificationResponse?.payload;

    if (!didLaunchFromNotification ||
        payload == null ||
        payload.trim().isEmpty) {
      return null;
    }

    return AppNotificationModel.fromPayload(payload);
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null || payload.trim().isEmpty) {
      return;
    }

    try {
      final notification = AppNotificationModel.fromPayload(payload);

      _openedNotificationsController.add(notification);
    } catch (error, stackTrace) {
      _openedNotificationsController.addError(error, stackTrace);
    }
  }
}
