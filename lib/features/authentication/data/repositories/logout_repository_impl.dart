import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/logout_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/logout_remote_data_source.dart';
import 'package:al_waleed/features/authentication/domain/repositories/logout_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource _remoteDataSource;
  final LogoutLocalDataSource _localDataSource;

  const LogoutRepositoryImpl({
    required LogoutRemoteDataSource remoteDataSource,
    required LogoutLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<AppErrorModel, void>> logout() async {
    final remoteResult = await _logoutRemotely();

    final remoteError = remoteResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (remoteError != null) {
      return Left(remoteError);
    }

    return _clearLocalSession();
  }

  Future<Either<AppErrorModel, void>> _logoutRemotely() async {
    try {
      await _remoteDataSource.logout();

      return const Right(null);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  Future<Either<AppErrorModel, void>> _clearLocalSession() async {
    try {
      await _localDataSource.clearSession();

      return const Right(null);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }
}
