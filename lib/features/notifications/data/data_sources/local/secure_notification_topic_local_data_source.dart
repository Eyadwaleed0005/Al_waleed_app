import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage_keys.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/notification_topic_local_data_source.dart';

class SecureNotificationTopicLocalDataSource
    implements NotificationTopicLocalDataSource {
  const SecureNotificationTopicLocalDataSource();

  @override
  Future<String?> getSubscribedGradeId() {
    return SecureStorageHelper.getString(
      key: SecureStorageKeys.notificationTopicGradeId,
    );
  }

  @override
  Future<void> saveSubscribedGradeId({required String gradeId}) {
    return SecureStorageHelper.saveString(
      key: SecureStorageKeys.notificationTopicGradeId,
      value: gradeId.trim(),
    );
  }

  @override
  Future<void> clearSubscribedGradeId() {
    return SecureStorageHelper.delete(
      key: SecureStorageKeys.notificationTopicGradeId,
    );
  }
}
