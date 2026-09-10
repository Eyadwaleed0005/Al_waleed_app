import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage_keys.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/login_local_data_source.dart';

class SecureLoginLocalDataSource implements LoginLocalDataSource {
  @override
  Future<void> saveGradeId({required String gradeId}) async {
    await SecureStorageHelper.saveString(
      key: SecureStorageKeys.gradeId,
      value: gradeId,
    );
  }

  @override
  Future<String?> getGradeId() async {
    return SecureStorageHelper.getString(key: SecureStorageKeys.gradeId);
  }

  @override
  Future<void> deleteGradeId() async {
    await SecureStorageHelper.delete(key: SecureStorageKeys.gradeId);
  }
}
