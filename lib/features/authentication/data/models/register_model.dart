import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/authentication/domain/entity/register_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required super.studentId,
    required super.gradeId,
    required super.name,
    required super.email,
    required super.phoneNumber,
    super.isActive = false,
    super.isLoggedIn = false,
    super.subscriptionStartAt,
    super.subscriptionEndAt,
  });

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.studentId: studentId,
      FirestoreFields.gradeId: gradeId,
      FirestoreFields.name: name,
      FirestoreFields.email: email,
      FirestoreFields.phoneNumber: phoneNumber,
      FirestoreFields.isActive: isActive,
      FirestoreFields.isLoggedIn: isLoggedIn,
      FirestoreFields.subscriptionStartAt: subscriptionStartAt == null
          ? null
          : Timestamp.fromDate(subscriptionStartAt!),
      FirestoreFields.subscriptionEndAt: subscriptionEndAt == null
          ? null
          : Timestamp.fromDate(subscriptionEndAt!),
      FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}
