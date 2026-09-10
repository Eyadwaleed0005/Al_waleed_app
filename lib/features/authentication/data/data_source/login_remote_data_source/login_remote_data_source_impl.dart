import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/login_remote_data_source/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/models/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirestoreService firestoreService;

  LoginRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestoreService,
  });

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    final userDoc = await firestoreService.getDocument(
      collectionPath: FirestoreCollections.students,
      documentId: uid,
    );

    if (userDoc.exists) {
      final data = userDoc.data();
      final bool isLoggedIn = data?[FirestoreFields.isLoggedIn] ?? false;

      if (isLoggedIn) {
        await firebaseAuth.signOut();

        throw FirebaseRemoteException(
          errorModel: const AppErrorModel(
            code: 'device-already-logged-in',
            message: 'الحساب مفتوح بالفعل على جهاز آخر. لا يمكنك تسجيل الدخول من أكثر من جهاز.',
            type: AppErrorType.server,
            isRetryable: false,
          ),
        );
      }
    }

    await firestoreService.patchData(
      collectionPath: FirestoreCollections.students,
      documentId: uid,
      data: {FirestoreFields.isLoggedIn: true},
    );

    return LoginModel(id: uid, email: email);
  }
}