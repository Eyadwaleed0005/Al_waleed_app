import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage_keys.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/cache/student_grade_local_data_source.dart';

class SecureStudentGradeLocalDataSource implements StudentGradeLocalDataSource {
  const SecureStudentGradeLocalDataSource();

  @override
  Future<String?> getGradeId() {
    return SecureStorageHelper.getString(key: SecureStorageKeys.gradeId);
  }

  @override
  Future<void> saveGradeId({required String gradeId}) async {
    final normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      throw const FormatException();
    }

    await SecureStorageHelper.saveString(
      key: SecureStorageKeys.gradeId,
      value: normalizedGradeId,
    );
  }

  @override
  Future<void> deleteGradeId() {
    return SecureStorageHelper.delete(key: SecureStorageKeys.gradeId);
  }
}
