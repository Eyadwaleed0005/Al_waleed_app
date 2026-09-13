import 'package:al_waleed/core/errors/handlers/firebase_auth_error_handler.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/models/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginRemoteDataSource implements LoginRemoteDataSource {
  FirebaseLoginRemoteDataSource({
    required this.firebaseAuth,
    required this.firestoreService,
    required this.loginLocalDataSource,
  });

  final FirebaseAuth firebaseAuth;
  final FirestoreService firestoreService;
  final LoginLocalDataSource loginLocalDataSource;

  @override
  Future<LoginModel> login({required String email, required String password}) {
    return FirebaseErrorHandler.execute<LoginModel>(() async {
      final String normalizedEmail = email.trim();

      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          );

      try {
        final User authenticatedUser = await _verifyAuthenticatedUser(
          userCredential,
        );

        final userDocument = await firestoreService.getDocument(
          collectionPath: FirestoreCollections.students,
          documentId: authenticatedUser.uid,
        );

        final studentData = userDocument.data();

        if (!userDocument.exists || studentData == null) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.studentRecordNotFoundCode,
          );
        }

        final bool isActive = studentData[FirestoreFields.isActive] == true;

        if (!isActive) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.subscriptionExpiredCode,
          );
        }

        final bool isLoggedIn = studentData[FirestoreFields.isLoggedIn] == true;

        if (isLoggedIn) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.deviceAlreadyLoggedInCode,
          );
        }

        final dynamic gradeIdValue = studentData[FirestoreFields.gradeId];

        if (gradeIdValue is! String || gradeIdValue.trim().isEmpty) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.missingGradeIdCode,
          );
        }

        final String gradeId = gradeIdValue.trim();

        // العملية المحلية يجب أن تنجح قبل تغيير حالة الطالب في Firestore.
        await loginLocalDataSource.saveGradeId(gradeId: gradeId);

        // فحص أخير قبل تحديث isLoggedIn.
        final User verifiedUser = await _verifyCurrentUser(
          expectedUserId: authenticatedUser.uid,
        );

        // آخر عملية قابلة للانتظار قبل إرجاع نجاح تسجيل الدخول.
        await firestoreService.patchData(
          collectionPath: FirestoreCollections.students,
          documentId: verifiedUser.uid,
          data: <String, dynamic>{FirestoreFields.isLoggedIn: true},
        );

        return LoginModel(
          id: verifiedUser.uid,
          email: verifiedUser.email ?? normalizedEmail,
        );
      } catch (_) {
        await _signOutSafely();
        rethrow;
      }
    });
  }

  Future<User> _verifyAuthenticatedUser(UserCredential userCredential) async {
    final User? credentialUser = userCredential.user;

    if (credentialUser == null) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
      );
    }

    await credentialUser.reload();

    return _verifyCurrentUser(expectedUserId: credentialUser.uid);
  }

  Future<User> _verifyCurrentUser({required String expectedUserId}) async {
    final User? currentUser = firebaseAuth.currentUser;

    if (currentUser == null ||
        currentUser.uid.trim().isEmpty ||
        currentUser.uid != expectedUserId) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
      );
    }

    final String? idToken = await currentUser.getIdToken(true);

    if (idToken == null || idToken.trim().isEmpty) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
      );
    }

    return currentUser;
  }

  Future<void> _signOutSafely() async {
    try {
      await firebaseAuth.signOut();
    } catch (_) {}
  }
}
