import 'package:al_waleed/core/errors/handlers/firebase_auth_error_handler.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/profile/data/data_source/my_subscription_remote_data_source.dart';
import 'package:al_waleed/features/profile/data/model/my_subscription_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMySubscriptionRemoteDataSource
    implements MySubscriptionRemoteDataSource {
  const FirebaseMySubscriptionRemoteDataSource({
    required this._firebaseAuth,
    required this._firestoreService,
  });

  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;

  @override
  Stream<MySubscriptionModel> streamMySubscription() {
    return FirebaseErrorHandler.executeStream<MySubscriptionModel>(() {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        FirebaseErrorHandler.throwAuthCode(
          FirebaseAuthErrorHandler.authenticatedUserNotFoundCode,
        );
      }

      return _firestoreService
          .streamDocument(
            collectionPath: FirestoreCollections.students,
            documentId: user.uid,
          )
          .map((document) {
            final data = document.data();

            if (!document.exists || data == null) {
              FirebaseErrorHandler.throwAuthCode(
                FirebaseAuthErrorHandler.studentRecordNotFoundCode,
              );
            }

            return MySubscriptionModel.fromFirestore(data);
          });
    });
  }
}
