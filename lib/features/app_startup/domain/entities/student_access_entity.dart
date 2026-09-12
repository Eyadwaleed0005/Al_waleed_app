class StudentAccessEntity {
  final String studentId;
  final String gradeId;
  final bool isActive;
  final DateTime subscriptionEndAt;

  const StudentAccessEntity({
    required this.studentId,
    required this.gradeId,
    required this.isActive,
    required this.subscriptionEndAt,
  });

  bool hasValidSubscription({
    required DateTime currentDate,
  }) {
    if (!isActive) {
      return false;
    }

    return subscriptionEndAt.toUtc().isAfter(
      currentDate.toUtc(),
    );
  }
}