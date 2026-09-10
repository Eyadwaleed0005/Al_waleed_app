class ProfileEntity {
  final StudentProfileEntity studentProfile;
  final GradeEntity grade;
  ProfileEntity({required this.studentProfile, required this.grade});
}

class StudentProfileEntity {
  final String name;
  final String gradeId;
  final String email;
  final String subscriptionStartAt;
  final String subscriptionEndAt;

  StudentProfileEntity({
    required this.name,
    required this.gradeId,
    required this.email,
    required this.subscriptionStartAt,
    required this.subscriptionEndAt,
  });
}

class GradeEntity {
  final String name;

  GradeEntity({required this.name});
}
