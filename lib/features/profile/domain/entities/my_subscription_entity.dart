class MySubscriptionEntity {
  const MySubscriptionEntity({
    required this.isActive,
    this.subscriptionStartAt,
    this.subscriptionEndAt,
  });

  final bool isActive;
  final DateTime? subscriptionStartAt;
  final DateTime? subscriptionEndAt;

  bool get hasSubscriptionPeriod {
    final startAt = subscriptionStartAt;
    final endAt = subscriptionEndAt;

    return startAt != null && endAt != null && endAt.isAfter(startAt);
  }

  int? remainingDays({required DateTime currentDate}) {
    if (!isActive) return 0;

    final endAt = subscriptionEndAt;

    if (endAt == null) return null;

    final remaining = endAt.toUtc().difference(currentDate.toUtc());

    if (remaining <= Duration.zero) return 0;

    return (remaining.inMicroseconds / Duration.microsecondsPerDay).ceil();
  }
}
