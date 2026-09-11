import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/security_screens/data/data_sources/secure_screen_data_source.dart';
import 'package:al_waleed/features/security_screens/data/error_handler/secure_screen_error_handler.dart';
import 'package:al_waleed/features/security_screens/domain/repositories/secure_screen_repository.dart';
import 'package:dartz/dartz.dart';

class SecureScreenRepositoryImpl implements SecureScreenRepository {
  final SecureScreenDataSource _dataSource;

  const SecureScreenRepositoryImpl({required SecureScreenDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<AppErrorModel, void>> enableSecureScreen() {
    return _execute(_dataSource.enableProtection);
  }

  @override
  Future<Either<AppErrorModel, void>> disableSecureScreen() {
    return _execute(_dataSource.disableProtection);
  }

  Future<Either<AppErrorModel, void>> _execute(
    Future<void> Function() operation,
  ) async {
    try {
      await operation();

      return const Right(null);
    } catch (error) {
      return Left(SecureScreenErrorHandler.handle(error));
    }
  }
}
