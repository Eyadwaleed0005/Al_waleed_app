import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source.dart';
import 'package:al_waleed/features/profile/data/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentProfileDataSourceImpl implements StudentProfileDataSource {
  final FirestoreService firestoreService;

  StudentProfileDataSourceImpl({required this.firestoreService});

  @override
  Future<ProfileModel> getStudentProfile() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return FirebaseErrorHandler.execute(() async {
      final studentDoc = await firestoreService.getDocument(
        collectionPath: FirestoreCollections.students,
        documentId: user.uid,
        //usid for testing
        //: 'UHQBF3JpvJMzurToH62QY9tWfd02',
      );
      final studentData = studentDoc.data();

      if (!studentDoc.exists || studentData == null) {
        FirebaseErrorHandler.throwFirestoreCode('not-found');
      }

      final gradeId = studentData[FirestoreFields.gradeId];
      if (gradeId.isEmpty) {
        FirebaseErrorHandler.throwFirestoreCode('not-found');
      }

      final gradeDoc = await firestoreService.getDocument(
        collectionPath: FirestoreCollections.grades,
        documentId: gradeId,
      );
      final gradeData = gradeDoc.data();

      if (!gradeDoc.exists || gradeData == null) {
        FirebaseErrorHandler.throwFirestoreCode('not-found');
      }

      try {
        return ProfileModel(
          studentProfile: StudentProfileModel.fromJson(studentData),
          grade: GradeModel.fromJson(gradeData),
        );
      } on FormatException {
        FirebaseErrorHandler.throwFirestoreCode('unknown');
      }
    });
  }
}
