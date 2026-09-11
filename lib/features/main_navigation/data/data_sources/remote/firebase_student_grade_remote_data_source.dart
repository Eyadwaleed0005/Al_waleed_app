import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/remote/student_grade_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStudentGradeRemoteDataSource
    implements StudentGradeRemoteDataSource {
  const FirebaseStudentGradeRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirestoreService firestoreService,
  }) : _firebaseAuth = firebaseAuth,
       _firestoreService = firestoreService;

  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;

  @override
  Stream<String> streamGradeId() {
    return FirebaseErrorHandler.executeStream(() {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        FirebaseErrorHandler.throwFirestoreCode('unauthenticated');
      }

      return _firestoreService
          .streamDocument(
            collectionPath: FirestoreCollections.students,
            documentId: currentUser.uid,
          )
          .map(_mapGradeId)
          .distinct();
    });
  }

  String _mapGradeId(DocumentSnapshot<Map<String, dynamic>> studentSnapshot) {
    final studentData = studentSnapshot.data();

    if (!studentSnapshot.exists || studentData == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    final gradeIdValue = studentData[FirestoreFields.gradeId];

    if (gradeIdValue is! String) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    final gradeId = gradeIdValue.trim();

    if (gradeId.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return gradeId;
  }
}
