import 'package:al_waleed/features/notifications/domain/entities/app_notification_type.dart';

class AppNotificationEntity {
  const AppNotificationEntity({
    required this.eventId,
    required this.type,
    required this.resourceId,
    required this.gradeId,
    required this.title,
    required this.body,
  });

  final String eventId;
  final AppNotificationType type;
  final String resourceId;
  final String gradeId;
  final String title;
  final String body;

  bool get canNavigate {
    return type != AppNotificationType.unknown;
  }
}