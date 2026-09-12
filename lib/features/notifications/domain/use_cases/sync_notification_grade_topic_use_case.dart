import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class SyncNotificationGradeTopicUseCase {
  final NotificationRepository _repository;

  const SyncNotificationGradeTopicUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, void>> call({
    required String gradeId,
  }) {
    return _repository.syncGradeTopic(
      gradeId: gradeId,
    );
  }
}