import 'package:al_waleed/features/app_startup/data/models/app_version_model.dart';
import 'package:al_waleed/features/app_startup/data/models/student_access_model.dart';

abstract interface class AppStartupRemoteDataSource {
  Future<AppVersionModel?> getAppVersion();

  Future<StudentAccessModel> getStudentAccess({
    required String studentId,
  });
}