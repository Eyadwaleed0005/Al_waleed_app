class ProfileEntity {
  final StudentProfileEntity studentProfile;
  final GradeEntity grade;

  const ProfileEntity({
    required this.studentProfile,
    required this.grade,
  });
}

class StudentProfileEntity {
  final String name;
  final String gradeId;
  final String email;
  final DateTime subscriptionStartAt;
  final DateTime subscriptionEndAt;

  const StudentProfileEntity({
    required this.name,
    required this.gradeId,
    required this.email,
    required this.subscriptionStartAt,
    required this.subscriptionEndAt,
  });
}

class GradeEntity {
  final String name;

  const GradeEntity({
    required this.name,
  });
}