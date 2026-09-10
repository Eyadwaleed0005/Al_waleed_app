class LiveSessionEntity {
  final String gradeId;
  final String platformType;
  final String meetingUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LiveSessionEntity({
    required this.gradeId,
    required this.platformType,
    required this.meetingUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}