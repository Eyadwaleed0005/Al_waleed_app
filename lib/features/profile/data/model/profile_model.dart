import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        subscriptionStartAt: studentProfile.subscriptionStartAt,
        subscriptionEndAt: studentProfile.subscriptionEndAt,
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
    required super.subscriptionStartAt,
    required super.subscriptionEndAt,
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
      subscriptionStartAt: _ProfileFieldReader.requiredDate(
        data: data,
        field: FirestoreFields.subscriptionStartAt,
      ),
      subscriptionEndAt: _ProfileFieldReader.requiredDate(
        data: data,
        field: FirestoreFields.subscriptionEndAt,
      ),
    );
  }

  StudentProfileEntity toEntity() {
    return StudentProfileEntity(
      name: name,
      gradeId: gradeId,
      email: email,
      subscriptionStartAt: subscriptionStartAt,
      subscriptionEndAt: subscriptionEndAt,
    );
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

  static DateTime requiredDate({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];
    final date = _parseDate(value);

    if (date == null) {
      throw const FormatException();
    }

    return date.toUtc();
  }

  static DateTime? _parseDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
