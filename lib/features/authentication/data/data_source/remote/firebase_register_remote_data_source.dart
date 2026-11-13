import 'package:al_waleed/core/errors/handlers/firebase_auth_error_handler.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/register_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/models/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRegisterRemoteDataSource implements RegisterRemoteDataSource {
  const FirebaseRegisterRemoteDataSource({
    required this.firebaseAuth,
    required this.firestoreService,
    required this.loginLocalDataSource,
  });

  final FirebaseAuth firebaseAuth;
  final FirestoreService firestoreService;
  final LoginLocalDataSource loginLocalDataSource;

  @override
  Future<RegisterModel> registerStudent({
    required String name,
    required String gradeId,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    return FirebaseErrorHandler.execute<RegisterModel>(() async {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedGradeId = gradeId.trim();

      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      final student = RegisterModel(
        studentId: user.uid,
        gradeId: normalizedGradeId,
        name: name.trim(),
        email: user.email ?? normalizedEmail,
        phoneNumber: phoneNumber.trim(),
        isActive: false,
        isLoggedIn: true,
        subscriptionStartAt: null,
        subscriptionEndAt: null,
      );

      try {
        await loginLocalDataSource.saveGradeId(gradeId: normalizedGradeId);

        await firestoreService.postData(
          collectionPath: FirestoreCollections.students,
          documentId: user.uid,
          data: student.toCreateMap(),
        );
      } catch (error, stackTrace) {
        await _rollbackAccount(user);
        Error.throwWithStackTrace(error, stackTrace);
      }

      return student;
    }, timeout: null);
  }

  Future<void> _rollbackAccount(User user) async {
    try {
      await user.delete();
    } catch (_) {
    } finally {
      try {
        await firebaseAuth.signOut();
      } catch (_) {}
    }
  }
}
