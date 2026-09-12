import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage_keys.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/lessons_local_data_source.dart';

class SecureLessonsLocalDataSource implements LessonsLocalDataSource {
  const SecureLessonsLocalDataSource();

  @override
  Future<String?> getGradeId() {
    return SecureStorageHelper.getString(
      key: SecureStorageKeys.gradeId,
    );
  }
}