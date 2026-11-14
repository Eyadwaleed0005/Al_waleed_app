class StudentAccessEntity {
  const StudentAccessEntity({
    required this.studentId,
    required this.gradeId,
    required this.isActive,
    this.subscriptionEndAt,
  });

  final String studentId;
  final String gradeId;
  final bool isActive;
  final DateTime? subscriptionEndAt;

  bool hasValidSubscription({required DateTime currentDate}) {
    final endAt = subscriptionEndAt;

    if (!isActive || endAt == null) {
      return false;
    }

    return endAt.toUtc().isAfter(currentDate.toUtc());
  }
}
