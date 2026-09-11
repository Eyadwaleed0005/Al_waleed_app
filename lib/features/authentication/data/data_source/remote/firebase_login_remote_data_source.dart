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
  final FirebaseAuth firebaseAuth;
  final FirestoreService firestoreService;
  final LoginLocalDataSource loginLocalDataSource;

  FirebaseLoginRemoteDataSource({
    required this.firebaseAuth,
    required this.firestoreService,
    required this.loginLocalDataSource,
  });

  @override
  Future<LoginModel> login({required String email, required String password}) {
    return FirebaseErrorHandler.execute<LoginModel>(() async {
      final normalizedEmail = email.trim();

      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      try {
        final userDocument = await firestoreService.getDocument(
          collectionPath: FirestoreCollections.students,
          documentId: user.uid,
        );

        final studentData = userDocument.data();

        if (!userDocument.exists || studentData == null) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.studentRecordNotFoundCode,
          );
        }

        final isActive = studentData[FirestoreFields.isActive] == true;

        if (!isActive) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.subscriptionExpiredCode,
          );
        }

        final isLoggedIn = studentData[FirestoreFields.isLoggedIn] == true;

        if (isLoggedIn) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.deviceAlreadyLoggedInCode,
          );
        }

        final gradeIdValue = studentData[FirestoreFields.gradeId];

        if (gradeIdValue is! String || gradeIdValue.trim().isEmpty) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.missingGradeIdCode,
          );
        }

        final gradeId = gradeIdValue.trim();

        await loginLocalDataSource.saveGradeId(gradeId: gradeId);

        await firestoreService.patchData(
          collectionPath: FirestoreCollections.students,
          documentId: user.uid,
          data: {FirestoreFields.isLoggedIn: true},
        );

        return LoginModel(id: user.uid, email: user.email ?? normalizedEmail);
      } catch (_) {
        await _signOutSafely();
        rethrow;
      }
    });
  }

  Future<void> _signOutSafely() async {
    try {
      await firebaseAuth.signOut();
    } catch (_) {}
  }
}
