import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:al_waleed/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class ShowLocalNotificationUseCase {
  final NotificationRepository _repository;

  const ShowLocalNotificationUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, void>> call({
    required AppNotificationEntity notification,
  }) {
    return _repository.showLocalNotification(
      notification: notification,
    );
  }
}