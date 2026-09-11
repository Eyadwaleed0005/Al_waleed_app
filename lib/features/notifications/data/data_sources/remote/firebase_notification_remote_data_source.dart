import 'package:al_waleed/features/notifications/data/data_sources/remote/notification_remote_data_source.dart';
import 'package:al_waleed/features/notifications/data/models/app_notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationRemoteDataSource
    implements NotificationRemoteDataSource {
  const FirebaseNotificationRemoteDataSource({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  static const String _gradeTopicPrefix = 'grade_';

  @override
  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }

  @override
  Future<void> subscribeToGradeTopic({required String gradeId}) {
    return _firebaseMessaging.subscribeToTopic(_createGradeTopic(gradeId));
  }

  @override
  Future<void> unsubscribeFromGradeTopic({required String gradeId}) {
    return _firebaseMessaging.unsubscribeFromTopic(_createGradeTopic(gradeId));
  }

  @override
  Stream<AppNotificationModel> streamForegroundNotifications() {
    return FirebaseMessaging.onMessage.map(
      AppNotificationModel.fromRemoteMessage,
    );
  }

  @override
  Stream<AppNotificationModel> streamOpenedNotifications() {
    return FirebaseMessaging.onMessageOpenedApp.map(
      AppNotificationModel.fromRemoteMessage,
    );
  }

  @override
  Future<AppNotificationModel?> getInitialNotification() async {
    final message = await _firebaseMessaging.getInitialMessage();

    if (message == null) {
      return null;
    }

    return AppNotificationModel.fromRemoteMessage(message);
  }

  String _createGradeTopic(String gradeId) {
    final normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      throw const FormatException();
    }

    final isValidTopic = RegExp(
      r'^[a-zA-Z0-9_.~%-]+$',
    ).hasMatch(normalizedGradeId);

    if (!isValidTopic) {
      throw const FormatException();
    }

    return '$_gradeTopicPrefix$normalizedGradeId';
  }
}
