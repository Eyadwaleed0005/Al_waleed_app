class ProfileEntity {
  final StudentProfileEntity studentProfile;
  final GradeEntity grade;

  const ProfileEntity({required this.studentProfile, required this.grade});
}

class StudentProfileEntity {
  final String name;
  final String gradeId;
  final String email;

  const StudentProfileEntity({
    required this.name,
    required this.gradeId,
    required this.email,
  });
}

class GradeEntity {
  final String name;

  const GradeEntity({required this.name});
}
