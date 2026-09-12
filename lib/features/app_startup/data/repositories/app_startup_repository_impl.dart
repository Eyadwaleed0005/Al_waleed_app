import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/app_startup/data/data_source/cache/app_startup_local_data_source.dart';
import 'package:al_waleed/features/app_startup/data/data_source/remote/app_startup_remote_data_source.dart';
import 'package:al_waleed/features/app_startup/domain/entities/app_version_entity.dart';
import 'package:al_waleed/features/app_startup/domain/entities/student_access_entity.dart';
import 'package:al_waleed/features/app_startup/domain/repositories/app_startup_repository.dart';
import 'package:dartz/dartz.dart';

class AppStartupRepositoryImpl implements AppStartupRepository {
  final AppStartupRemoteDataSource _remoteDataSource;
  final AppStartupLocalDataSource _localDataSource;

  const AppStartupRepositoryImpl({
    required AppStartupRemoteDataSource remoteDataSource,
    required AppStartupLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  String? getCurrentUserId() {
    return _localDataSource.getCurrentUserId();
  }

  @override
  Future<Either<AppErrorModel, int>> getInstalledBuildNumber() async {
    try {
      final buildNumber = await _localDataSource.getInstalledBuildNumber();

      return Right(buildNumber);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, AppVersionEntity?>> getAppVersion() async {
    try {
      final versionModel = await _remoteDataSource.getAppVersion();

      return Right(versionModel?.toEntity());
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, StudentAccessEntity>> getStudentAccess({
    required String studentId,
  }) async {
    try {
      final studentAccessModel = await _remoteDataSource.getStudentAccess(
        studentId: studentId,
      );

      return Right(studentAccessModel.toEntity());
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }
}
