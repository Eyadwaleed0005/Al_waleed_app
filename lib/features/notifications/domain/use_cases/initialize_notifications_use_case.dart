import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class InitializeNotificationsUseCase {
  final NotificationRepository _repository;

  const InitializeNotificationsUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, void>> call() {
    return _repository.initialize();
  }
}