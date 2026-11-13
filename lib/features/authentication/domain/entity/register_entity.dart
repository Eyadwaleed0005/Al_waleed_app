class RegisterEntity {
  const RegisterEntity({
    required this.studentId,
    required this.gradeId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
    required this.isLoggedIn,
    this.subscriptionStartAt,
    this.subscriptionEndAt,
  });

  final String studentId;
  final String gradeId;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isActive;
  final bool isLoggedIn;
  final DateTime? subscriptionStartAt;
  final DateTime? subscriptionEndAt;
}
