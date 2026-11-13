import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({required super.studentProfile, required super.grade});

  factory ProfileModel.fromFirestore({
    required Map<String, dynamic> studentData,
    required Map<String, dynamic> gradeData,
  }) {
    return ProfileModel(
      studentProfile: StudentProfileModel.fromFirestore(studentData),
      grade: GradeModel.fromFirestore(gradeData),
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      studentProfile: StudentProfileEntity(
        name: studentProfile.name,
        gradeId: studentProfile.gradeId,
        email: studentProfile.email,
      ),
      grade: GradeEntity(name: grade.name),
    );
  }
}

class StudentProfileModel extends StudentProfileEntity {
  const StudentProfileModel({
    required super.name,
    required super.gradeId,
    required super.email,
  });

  factory StudentProfileModel.fromFirestore(Map<String, dynamic> data) {
    return StudentProfileModel(
      name: _ProfileFieldReader.requiredString(
        data: data,
        field: FirestoreFields.name,
      ),
      gradeId: _ProfileFieldReader.requiredString(
        data: data,
        field: FirestoreFields.gradeId,
      ),
      email: _ProfileFieldReader.requiredString(
        data: data,
        field: FirestoreFields.email,
      ),
    );
  }

  StudentProfileEntity toEntity() {
    return StudentProfileEntity(name: name, gradeId: gradeId, email: email);
  }
}

class GradeModel extends GradeEntity {
  const GradeModel({required super.name});

  factory GradeModel.fromFirestore(Map<String, dynamic> data) {
    return GradeModel(
      name: _ProfileFieldReader.requiredString(
        data: data,
        field: FirestoreFields.name,
      ),
    );
  }

  GradeEntity toEntity() {
    return GradeEntity(name: name);
  }
}

abstract final class _ProfileFieldReader {
  const _ProfileFieldReader._();

  static String requiredString({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! String) {
      throw const FormatException();
    }

    final normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      throw const FormatException();
    }

    return normalizedValue;
  }
}
