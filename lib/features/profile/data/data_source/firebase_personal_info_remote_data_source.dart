import 'package:al_waleed/core/errors/handlers/firebase_auth_error_handler.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/profile/data/data_source/personal_info_remote_data_source.dart';
import 'package:al_waleed/features/profile/data/model/personal_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePersonalInfoRemoteDataSource
    implements PersonalInfoRemoteDataSource {
  const FirebasePersonalInfoRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirestoreService firestoreService,
    required FirebaseFunctions firebaseFunctions,
  }) : _firebaseAuth = firebaseAuth,
       _firestoreService = firestoreService,
       _firebaseFunctions = firebaseFunctions;

  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;
  final FirebaseFunctions _firebaseFunctions;

  @override
  Future<PersonalInfoModel> getPersonalInfo() {
    return FirebaseErrorHandler.execute<PersonalInfoModel>(() async {
      final user = await _getAuthenticatedUser();

      final studentData = await _getRequiredStudentData(studentId: user.uid);

      return PersonalInfoModel.fromFirestore(
        documentId: user.uid,
        data: {...studentData, FirestoreFields.email: _getCurrentEmail(user)},
      );
    }, timeout: null);
  }

  @override
  Future<void> updatePersonalInfo({
    required String name,
    required String phoneNumber,
    required String email,
    String? currentPassword,
  }) {
    return FirebaseErrorHandler.execute<void>(() async {
      final user = await _getAuthenticatedUser();

      await _getRequiredStudentData(studentId: user.uid);

      final normalizedName = _normalizeRequiredValue(name);
      final normalizedPhoneNumber = _normalizeRequiredValue(phoneNumber);
      final normalizedEmail = _normalizeRequiredValue(email).toLowerCase();

      final currentEmail = _getCurrentEmail(user);
      final hasEmailChanged = normalizedEmail != currentEmail;

      if (hasEmailChanged) {
        final password = currentPassword;

        if (password == null || password.isEmpty) {
          FirebaseErrorHandler.throwAuthCode('requires-recent-login');
        }

        await _reauthenticate(user: user, currentPassword: password);

        final authenticatedUser = _firebaseAuth.currentUser;

        if (authenticatedUser == null || authenticatedUser.uid != user.uid) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
          );
        }

        await authenticatedUser.getIdToken(true);

        await _firebaseFunctions.httpsCallable('updateMyEmail').call(
          <String, dynamic>{'newEmail': normalizedEmail},
        );

        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: normalizedEmail,
          password: password,
        );

        if (result.user?.uid != user.uid) {
          FirebaseErrorHandler.throwAuthCode(
            FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
          );
        }
      }

      if (_firebaseAuth.currentUser?.uid != user.uid) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      await _firestoreService.patchData(
        collectionPath: FirestoreCollections.students,
        documentId: user.uid,
        data: {
          FirestoreFields.name: normalizedName,
          FirestoreFields.phoneNumber: normalizedPhoneNumber,
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        },
      );
    }, timeout: null);
  }

  Future<void> _reauthenticate({
    required User user,
    required String currentPassword,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: _getCurrentEmail(user),
      password: currentPassword,
    );

    try {
      final result = await user.reauthenticateWithCredential(credential);

      if (result.user?.uid != user.uid) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password' ||
          error.code == 'invalid-credential' ||
          error.code == 'invalid-login-credentials') {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.currentPasswordIncorrectCode,
        );
      }

      rethrow;
    }
  }

  Future<User> _getAuthenticatedUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
      );
    }

    await user.reload();

    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null || currentUser.uid != user.uid) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
      );
    }

    return currentUser;
  }

  Future<Map<String, dynamic>> _getRequiredStudentData({
    required String studentId,
  }) async {
    final document = await _firestoreService.getDocument(
      collectionPath: FirestoreCollections.students,
      documentId: studentId,
    );

    final data = document.data();

    if (!document.exists || data == null) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.studentRecordNotFoundCode,
      );
    }

    return data;
  }

  String _getCurrentEmail(User user) {
    final email = user.email?.trim().toLowerCase();

    if (email == null || email.isEmpty) {
      FirebaseErrorHandler.throwAuthCode(
        FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
      );
    }

    return email;
  }

  String _normalizeRequiredValue(String value) {
    final normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }

    return normalizedValue;
  }
}
