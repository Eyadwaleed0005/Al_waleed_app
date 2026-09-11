import 'dart:convert';

import 'package:al_waleed/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    required super.eventId,
    required super.type,
    required super.resourceId,
    required super.gradeId,
    required super.title,
    required super.body,
  });

  factory AppNotificationModel.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;

    return AppNotificationModel(
      eventId: _readString(
        data[_NotificationFields.eventId],
        fallback: message.messageId,
      ),
      type: _parseType(data[_NotificationFields.type]),
      resourceId: _readString(data[_NotificationFields.resourceId]),
      gradeId: _readString(data[_NotificationFields.gradeId]),
      title: _readString(
        data[_NotificationFields.title],
        fallback: message.notification?.title,
      ),
      body: _readString(
        data[_NotificationFields.body],
        fallback: message.notification?.body,
      ),
    );
  }

  factory AppNotificationModel.fromMap(Map<String, dynamic> map) {
    return AppNotificationModel(
      eventId: _readString(map[_NotificationFields.eventId]),
      type: _parseType(map[_NotificationFields.type]),
      resourceId: _readString(map[_NotificationFields.resourceId]),
      gradeId: _readString(map[_NotificationFields.gradeId]),
      title: _readString(map[_NotificationFields.title]),
      body: _readString(map[_NotificationFields.body]),
    );
  }

  factory AppNotificationModel.fromPayload(String payload) {
    final decodedPayload = jsonDecode(payload);

    if (decodedPayload is! Map) {
      throw const FormatException('Invalid notification payload.');
    }

    return AppNotificationModel.fromMap(
      Map<String, dynamic>.from(decodedPayload),
    );
  }

  factory AppNotificationModel.fromEntity(AppNotificationEntity entity) {
    return AppNotificationModel(
      eventId: entity.eventId,
      type: entity.type,
      resourceId: entity.resourceId,
      gradeId: entity.gradeId,
      title: entity.title,
      body: entity.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      _NotificationFields.eventId: eventId,
      _NotificationFields.type: _typeToValue(type),
      _NotificationFields.resourceId: resourceId,
      _NotificationFields.gradeId: gradeId,
      _NotificationFields.title: title,
      _NotificationFields.body: body,
    };
  }

  String toPayload() {
    return jsonEncode(toMap());
  }

  AppNotificationEntity toEntity() {
    return AppNotificationEntity(
      eventId: eventId,
      type: type,
      resourceId: resourceId,
      gradeId: gradeId,
      title: title,
      body: body,
    );
  }

  static AppNotificationType _parseType(Object? value) {
    final normalizedValue = value?.toString().trim();

    return switch (normalizedValue) {
      'lesson' => AppNotificationType.lesson,
      'studyNote' => AppNotificationType.studyNote,
      'exam' => AppNotificationType.exam,
      'liveSession' => AppNotificationType.liveSession,
      _ => AppNotificationType.unknown,
    };
  }

  static String _typeToValue(AppNotificationType type) {
    return switch (type) {
      AppNotificationType.lesson => 'lesson',
      AppNotificationType.studyNote => 'studyNote',
      AppNotificationType.exam => 'exam',
      AppNotificationType.liveSession => 'liveSession',
      AppNotificationType.unknown => 'unknown',
    };
  }

  static String _readString(Object? value, {String? fallback}) {
    final stringValue = value?.toString().trim() ?? '';

    if (stringValue.isNotEmpty) {
      return stringValue;
    }

    return fallback?.trim() ?? '';
  }
}

abstract final class _NotificationFields {
  const _NotificationFields._();

  static const String eventId = 'eventId';
  static const String type = 'type';
  static const String resourceId = 'resourceId';
  static const String gradeId = 'gradeId';
  static const String title = 'title';
  static const String body = 'body';
}
