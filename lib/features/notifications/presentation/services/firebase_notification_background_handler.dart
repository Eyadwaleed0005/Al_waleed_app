import 'dart:io';

import 'package:al_waleed/firebase_options.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/flutter_local_notification_data_source.dart';
import 'package:al_waleed/features/notifications/data/models/app_notification_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseNotificationBackgroundHandler(
  RemoteMessage message,
) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (!Platform.isAndroid) {
    return;
  }

  if (message.notification != null) {
    return;
  }

  final notification = AppNotificationModel.fromRemoteMessage(message);

  if (notification.title.isEmpty && notification.body.isEmpty) {
    return;
  }

  final localDataSource = FlutterLocalNotificationDataSource(
    localNotificationsPlugin: FlutterLocalNotificationsPlugin(),
  );

  await localDataSource.initialize(requestPermission: false);

  await localDataSource.showNotification(notification: notification);
}
