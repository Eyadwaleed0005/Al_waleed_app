import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/app_startup/domain/entities/app_version_entity.dart';
import 'package:al_waleed/features/app_startup/domain/entities/student_access_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class AppStartupRepository {
  String? getCurrentUserId();

  Future<Either<AppErrorModel, int>>
  getInstalledBuildNumber();

  Future<Either<AppErrorModel, AppVersionEntity?>>
  getAppVersion();

  Future<Either<AppErrorModel, StudentAccessEntity>>
  getStudentAccess({
    required String studentId,
  });
}