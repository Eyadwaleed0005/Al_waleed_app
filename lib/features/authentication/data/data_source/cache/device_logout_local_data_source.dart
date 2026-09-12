import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/shared_preferences/shared_preferences.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/logout_local_data_source.dart';

class DeviceLogoutLocalDataSource
    implements LogoutLocalDataSource {
  const DeviceLogoutLocalDataSource();

  @override
  Future<void> clearSession() async {
    await Future.wait<void>([
      SecureStorageHelper.clearAll(),
      SharedPreferencesHelper.clearAll(),
    ]);
  }
}