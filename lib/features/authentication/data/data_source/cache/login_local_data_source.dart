abstract interface class LoginLocalDataSource {
  Future<void> saveGradeId({
    required String gradeId,
  });

  Future<String?> getGradeId();

  Future<void> deleteGradeId();
}