import 'package:al_waleed/features/authentication/data/data_source/cache/logout_local_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/delete_account_local_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeviceDeleteAccountLocalDataSource
    implements DeleteAccountLocalDataSource {
  const DeviceDeleteAccountLocalDataSource({
    required FirebaseAuth firebaseAuth,
    required LogoutLocalDataSource logoutLocalDataSource,
  }) : _firebaseAuth = firebaseAuth,
       _logoutLocalDataSource = logoutLocalDataSource;

  final FirebaseAuth _firebaseAuth;
  final LogoutLocalDataSource _logoutLocalDataSource;

  @override
  Future<void> clearAccountData() async {
    await Future.wait<void>([
      _firebaseAuth.signOut(),
      _logoutLocalDataSource.clearSession(),
    ]);
  }
}
