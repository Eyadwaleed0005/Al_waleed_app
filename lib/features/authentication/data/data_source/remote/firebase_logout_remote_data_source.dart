import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/logout_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLogoutRemoteDataSource implements LogoutRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;

  const FirebaseLogoutRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirestoreService firestoreService,
  }) : _firebaseAuth = firebaseAuth,
       _firestoreService = firestoreService;

  @override
  Future<void> logout() {
    return FirebaseErrorHandler.execute<void>(() async {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return;
      }

      await _firestoreService.patchData(
        collectionPath: FirestoreCollections.students,
        documentId: currentUser.uid,
        data: {FirestoreFields.isLoggedIn: false},
      );

      await _firebaseAuth.signOut();
    });
  }
}
