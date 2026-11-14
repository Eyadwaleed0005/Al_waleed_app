import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/profile/domain/entities/personal_info_entity.dart';

class PersonalInfoModel extends PersonalInfoEntity {
  const PersonalInfoModel({
    required super.studentId,
    required super.name,
    required super.phoneNumber,
    required super.email,
  });

  factory PersonalInfoModel.fromFirestore({
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    final studentId = documentId.trim();

    if (studentId.isEmpty) {
      throw const FormatException('Student document ID is missing.');
    }

    return PersonalInfoModel(
      studentId: studentId,
      name: _readRequiredString(data: data, field: FirestoreFields.name),
      phoneNumber: _readRequiredString(
        data: data,
        field: FirestoreFields.phoneNumber,
      ),
      email: _readRequiredString(data: data, field: FirestoreFields.email),
    );
  }

  PersonalInfoEntity toEntity() {
    return PersonalInfoEntity(
      studentId: studentId,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
    );
  }

  static String _readRequiredString({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Missing or invalid field: $field');
    }

    return value.trim();
  }
}
