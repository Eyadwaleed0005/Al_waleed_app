import 'dart:async';
import 'dart:io';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_documents.dart';
import 'package:al_waleed/features/app_startup/data/data_source/remote/app_startup_remote_data_source.dart';
import 'package:al_waleed/features/app_startup/data/models/app_version_model.dart';
import 'package:al_waleed/features/app_startup/data/models/student_access_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAppStartupRemoteDataSource implements AppStartupRemoteDataSource {
  final FirebaseFirestore _firestore;

  const FirebaseAppStartupRemoteDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<AppVersionModel?> getAppVersion() {
    return FirebaseErrorHandler.execute<AppVersionModel?>(() async {
      final documentReference = _firestore
          .collection(FirestoreCollections.appConfig)
          .doc(FirestoreDocuments.appVersion);

      final snapshot = await _getFromServerThenCache(
        documentReference: documentReference,
      );

      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      try {
        if (Platform.isAndroid) {
          return AppVersionModel.fromAndroid(data);
        }

        if (Platform.isIOS) {
          return AppVersionModel.fromIos(data);
        }

        return null;
      } on FormatException {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }
    });
  }

  @override
  Future<StudentAccessModel> getStudentAccess({required String studentId}) {
    return FirebaseErrorHandler.execute<StudentAccessModel>(() async {
      final normalizedStudentId = studentId.trim();

      if (normalizedStudentId.isEmpty) {
        FirebaseErrorHandler.throwFirestoreCode('unauthenticated');
      }

      final documentReference = _firestore
          .collection(FirestoreCollections.students)
          .doc(normalizedStudentId);

      final snapshot = await _getFromServerThenCache(
        documentReference: documentReference,
      );

      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        FirebaseErrorHandler.throwFirestoreCode('not-found');
      }

      try {
        return StudentAccessModel.fromFirestore(
          documentId: snapshot.id,
          data: data,
        );
      } on FormatException {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getFromServerThenCache({
    required DocumentReference<Map<String, dynamic>> documentReference,
  }) async {
    try {
      return await documentReference
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 5));
    } on FirebaseException catch (error) {
      if (_isSecurityError(error)) {
        rethrow;
      }

      return _getFromCache(documentReference: documentReference);
    } on TimeoutException {
      return _getFromCache(documentReference: documentReference);
    } catch (_) {
      return _getFromCache(documentReference: documentReference);
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getFromCache({
    required DocumentReference<Map<String, dynamic>> documentReference,
  }) {
    return documentReference.get(const GetOptions(source: Source.cache));
  }

  bool _isSecurityError(FirebaseException error) {
    final errorModel = FirebaseErrorHandler.handle(error);

    return errorModel.type == AppErrorType.authorization ||
        errorModel.type == AppErrorType.authentication;
  }
}
