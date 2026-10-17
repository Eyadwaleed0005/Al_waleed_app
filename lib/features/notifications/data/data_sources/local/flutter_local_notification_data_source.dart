import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/local_notification_data_source.dart';
import 'package:al_waleed/features/notifications/data/models/app_notification_model.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_type.dart';
import 'package:flutter/foundation.dart';
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

  static const int _maxImageBytes = 2 * 1024 * 1024;

  @override
  Future<void> initialize({bool requestPermission = true}) async {
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

    final androidPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_androidChannel);

    if (requestPermission) {
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  @override
  Future<void> showNotification({
    required AppNotificationModel notification,
  }) async {
    final id = notification.eventId.hashCode & 0x7fffffff;

    await _show(id: id, notification: notification);

    final shouldLoadImage =
        Platform.isAndroid &&
        notification.type == AppNotificationType.lesson &&
        notification.imageUrl.trim().isNotEmpty;

    if (!shouldLoadImage) {
      return;
    }

    final imageBytes = await _downloadThumbnail(notification.imageUrl);

    if (imageBytes == null) {
      return;
    }

    try {
      await _show(id: id, notification: notification, imageBytes: imageBytes);
    } catch (error) {
      debugPrint('Notification image update failed: $error');
    }
  }

  Future<void> _show({
    required int id,
    required AppNotificationModel notification,
    Uint8List? imageBytes,
  }) {
    final StyleInformation style;

    if (imageBytes != null) {
      style = BigPictureStyleInformation(
        ByteArrayAndroidBitmap(imageBytes),
        contentTitle: notification.title,
        summaryText: notification.body,
        hideExpandedLargeIcon: true,
      );
    } else {
      style = BigTextStyleInformation(
        notification.body,
        contentTitle: notification.title,
      );
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'إشعارات منصة الوليد',
        channelDescription:
            'إشعارات الدروس والمذكرات والامتحانات والبث المباشر',
        icon: _notificationIcon,
        largeIcon: const DrawableResourceAndroidBitmap('al_waleed_logo'),
        color: ColorPalette.primary,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: _notificationSound,
        enableVibration: true,
        onlyAlertOnce: true,
        styleInformation: style,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    return _localNotificationsPlugin.show(
      id: id,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: notification.toPayload(),
    );
  }

  Future<Uint8List?> _downloadThumbnail(String imageUrl) async {
    final uri = Uri.tryParse(imageUrl.trim());

    if (uri == null || uri.scheme != 'https' || uri.host != 'img.youtube.com') {
      return null;
    }

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);

    try {
      return await _readImage(client, uri).timeout(const Duration(seconds: 5));
    } catch (error) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<Uint8List?> _readImage(HttpClient client, Uri uri) async {
    final request = await client.getUrl(uri);

    request.followRedirects = false;

    final response = await request.close();

    if (response.statusCode != HttpStatus.ok) {
      return null;
    }

    final mimeType = response.headers.contentType?.mimeType;

    if (mimeType == null || !mimeType.startsWith('image/')) {
      return null;
    }

    if (response.contentLength > _maxImageBytes) {
      return null;
    }

    final bytes = BytesBuilder(copy: false);
    int receivedBytes = 0;

    await for (final chunk in response) {
      receivedBytes += chunk.length;

      if (receivedBytes > _maxImageBytes) {
        return null;
      }

      bytes.add(chunk);
    }

    if (receivedBytes == 0) {
      return null;
    }

    return bytes.takeBytes();
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
