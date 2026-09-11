abstract interface class NotificationTopicLocalDataSource {
  Future<String?> getSubscribedGradeId();

  Future<void> saveSubscribedGradeId({
    required String gradeId,
  });

  Future<void> clearSubscribedGradeId();
}