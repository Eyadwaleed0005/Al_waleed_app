import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage_keys.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/study_notes_local_data_source.dart';

class SecureStudyNotesLocalDataSource
    implements StudyNotesLocalDataSource {
  const SecureStudyNotesLocalDataSource();

  @override
  Future<String?> getGradeId() {
    return SecureStorageHelper.getString(
      key: SecureStorageKeys.gradeId,
    );
  }
}