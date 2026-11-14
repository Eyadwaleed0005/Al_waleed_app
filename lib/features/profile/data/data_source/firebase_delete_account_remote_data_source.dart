import 'package:al_waleed/core/errors/handlers/firebase_auth_error_handler.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/profile/data/data_source/delete_account_remote_data_source.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDeleteAccountRemoteDataSource
    implements DeleteAccountRemoteDataSource {
  const FirebaseDeleteAccountRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFunctions firebaseFunctions,
  }) : _firebaseAuth = firebaseAuth,
       _firebaseFunctions = firebaseFunctions;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFunctions _firebaseFunctions;

  @override
  Future<void> deleteAccount({required String currentPassword}) {
    return FirebaseErrorHandler.execute<void>(() async {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      final email = user.email?.trim();

      if (email == null || email.isEmpty) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      if (currentPassword.isEmpty) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.currentPasswordIncorrectCode,
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      final authenticationResult = await user.reauthenticateWithCredential(
        credential,
      );

      if (authenticationResult.user?.uid != user.uid) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      final authenticatedUser = _firebaseAuth.currentUser;

      if (authenticatedUser == null || authenticatedUser.uid != user.uid) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      await authenticatedUser.getIdToken(true);

      final callable = _firebaseFunctions.httpsCallable(
        'deleteMyAccount',
        options: HttpsCallableOptions(timeout: const Duration(minutes: 5)),
      );

      final result = await callable.call<Map<String, dynamic>>();

      if (result.data['success'] != true) {
        FirebaseErrorHandler.throwFunctionsCode('invalid-response');
      }
    }, timeout: null);
  }
}
