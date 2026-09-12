import 'dart:async';

import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source.dart';
import 'package:al_waleed/features/profile/data/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStudentProfileDataSource implements StudentProfileDataSource {
  final FirestoreService _firestoreService;
  final FirebaseAuth _firebaseAuth;

  const FirebaseStudentProfileDataSource({
    required FirestoreService firestoreService,
    required FirebaseAuth firebaseAuth,
  }) : _firestoreService = firestoreService,
       _firebaseAuth = firebaseAuth;

  @override
  Stream<ProfileModel> streamStudentProfile() {
    return FirebaseErrorHandler.executeStream(() {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        FirebaseErrorHandler.throwFirestoreCode('unauthenticated');
      }

      return _createProfileStream(studentId: currentUser.uid);
    });
  }

  Stream<ProfileModel> _createProfileStream({required String studentId}) {
    late final StreamController<ProfileModel> controller;

    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
    studentSubscription;

    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
    gradeSubscription;

    Map<String, dynamic>? latestStudentData;
    Map<String, dynamic>? latestGradeData;

    String? activeGradeId;

    int gradeSubscriptionVersion = 0;
    bool isDisposed = false;

    void addError(Object error, [StackTrace? stackTrace]) {
      if (isDisposed || controller.isClosed) return;

      controller.addError(error, stackTrace ?? StackTrace.current);
    }

    void emitProfileIfReady() {
      if (isDisposed || controller.isClosed) return;

      final studentData = latestStudentData;
      final gradeData = latestGradeData;

      if (studentData == null || gradeData == null) {
        return;
      }

      try {
        final profile = _createProfileModel(
          studentData: studentData,
          gradeData: gradeData,
        );

        controller.add(profile);
      } catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }

    Future<void> listenToGrade({required String gradeId}) async {
      if (isDisposed) return;

      final isListeningToSameGrade =
          activeGradeId == gradeId && gradeSubscription != null;

      if (isListeningToSameGrade) {
        emitProfileIfReady();
        return;
      }

      final currentVersion = ++gradeSubscriptionVersion;

      activeGradeId = gradeId;
      latestGradeData = null;

      await gradeSubscription?.cancel();
      gradeSubscription = null;

      if (isDisposed || currentVersion != gradeSubscriptionVersion) {
        return;
      }

      gradeSubscription = _firestoreService
          .streamDocument(
            collectionPath: FirestoreCollections.grades,
            documentId: gradeId,
          )
          .listen(
            (gradeSnapshot) {
              if (isDisposed || currentVersion != gradeSubscriptionVersion) {
                return;
              }

              try {
                latestGradeData = _readRequiredDocumentData(
                  snapshot: gradeSnapshot,
                );

                emitProfileIfReady();
              } catch (error, stackTrace) {
                addError(error, stackTrace);
              }
            },
            onError: (Object error, StackTrace stackTrace) {
              addError(error, stackTrace);
            },
          );
    }

    void startListeningToGrade({required String gradeId}) {
      unawaited(() async {
        try {
          await listenToGrade(gradeId: gradeId);
        } catch (error, stackTrace) {
          addError(error, stackTrace);
        }
      }());
    }

    controller = StreamController<ProfileModel>(
      onListen: () {
        studentSubscription = _firestoreService
            .streamDocument(
              collectionPath: FirestoreCollections.students,
              documentId: studentId,
            )
            .listen(
              (studentSnapshot) {
                try {
                  final studentData = _readRequiredDocumentData(
                    snapshot: studentSnapshot,
                  );

                  final gradeId = _readRequiredGradeId(studentData);

                  latestStudentData = studentData;

                  final isListeningToSameGrade =
                      activeGradeId == gradeId && gradeSubscription != null;

                  if (isListeningToSameGrade) {
                    emitProfileIfReady();
                    return;
                  }

                  startListeningToGrade(gradeId: gradeId);
                } catch (error, stackTrace) {
                  addError(error, stackTrace);
                }
              },
              onError: (Object error, StackTrace stackTrace) {
                addError(error, stackTrace);
              },
            );
      },
      onCancel: () async {
        isDisposed = true;
        gradeSubscriptionVersion++;

        final subscriptions = <Future<void>>[
          if (studentSubscription != null) studentSubscription!.cancel(),
          if (gradeSubscription != null) gradeSubscription!.cancel(),
        ];

        studentSubscription = null;
        gradeSubscription = null;

        latestStudentData = null;
        latestGradeData = null;
        activeGradeId = null;

        await Future.wait(subscriptions);
      },
    );

    return controller.stream;
  }

  Map<String, dynamic> _readRequiredDocumentData({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
  }) {
    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return data;
  }

  String _readRequiredGradeId(Map<String, dynamic> studentData) {
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

  ProfileModel _createProfileModel({
    required Map<String, dynamic> studentData,
    required Map<String, dynamic> gradeData,
  }) {
    try {
      return ProfileModel.fromFirestore(
        studentData: studentData,
        gradeData: gradeData,
      );
    } catch (_) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }
  }
}
