import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/profile/data/data_source/delete_account_local_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/delete_account_remote_data_source.dart';
import 'package:al_waleed/features/profile/domain/repositories/delete_account_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  const DeleteAccountRepositoryImpl({
    required DeleteAccountRemoteDataSource remoteDataSource,
    required DeleteAccountLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final DeleteAccountRemoteDataSource _remoteDataSource;
  final DeleteAccountLocalDataSource _localDataSource;

  @override
  Future<Either<AppErrorModel, Unit>> deleteAccount({
    required String currentPassword,
  }) async {
    try {
      await _remoteDataSource.deleteAccount(currentPassword: currentPassword);

      await _localDataSource.clearAccountData();

      return const Right(unit);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }
}
