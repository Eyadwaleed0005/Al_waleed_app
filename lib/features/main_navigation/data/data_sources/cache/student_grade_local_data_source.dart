abstract interface class StudentGradeLocalDataSource {
  Future<String?> getGradeId();

  Future<void> saveGradeId({
    required String gradeId,
  });

  Future<void> deleteGradeId();
}