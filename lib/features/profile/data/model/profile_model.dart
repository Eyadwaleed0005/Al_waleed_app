import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({required super.studentProfile, required super.grade});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      studentProfile: StudentProfileModel.fromJson(json['studentProfile']),
      grade: GradeModel.fromJson(json['grade']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'studentProfile': studentProfile, 'grade': grade};
  }

  ProfileEntity toEntity() {
    return ProfileEntity(studentProfile: studentProfile, grade: grade);
  }
}

class StudentProfileModel extends StudentProfileEntity {
  StudentProfileModel({
    required super.name,
    required super.gradeId,
    required super.email,
    required super.subscriptionStartAt,
    required super.subscriptionEndAt,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      name: json['name'],
      gradeId: json['gradeId'],
      email: json['email'],
      subscriptionStartAt: _requiredDate(json, 'subscriptionStartAt'),
      subscriptionEndAt: _requiredDate(json, 'subscriptionEndAt'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gradeId': gradeId,
      'email': email,
      'subscriptionStartAt': subscriptionStartAt,
      'subscriptionEndAt': subscriptionEndAt,
    };
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
  GradeModel({required super.name});

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  GradeEntity toEntity() {
    return GradeEntity(name: name);
  }
}

String _requiredDate(Map<String, dynamic> json, String field) {
  final value = json[field];

  if (value is Timestamp) {
    return value.toDate().toIso8601String();
  }

  if (value is DateTime) {
    return value.toIso8601String();
  }

  throw FormatException('Missing or invalid $field.');
}
