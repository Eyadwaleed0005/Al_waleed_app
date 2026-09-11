import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/secure_screen/data/data_sources/secure_screen_data_source.dart';
import 'package:al_waleed/features/secure_screen/domain/repositories/secure_screen_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

class SecureScreenRepositoryImpl
    implements SecureScreenRepository {
  const SecureScreenRepositoryImpl({required this._dataSource});

  final SecureScreenDataSource _dataSource;

  @override
  Future<Either<AppErrorModel, void>> enableSecureScreen() {
    return _execute(() async {
      await _dataSource.preventScreenshotOn();
      await _dataSource.preventRecordingOn();
    });
  }

  @override
  Future<Either<AppErrorModel, void>> disableSecureScreen() {
    return _execute(() async {
      await _dataSource.preventScreenshotOff();
      await _dataSource.preventRecordingOff();
    });
  }

  Future<Either<AppErrorModel, void>> _execute(
    Future<void> Function() operation,
  ) async {
    try {
      await operation();

      return const Right(null);
    } on MissingPluginException catch (error) {
      return Left(
        AppErrorModel(
          code: 'secure_screen/unimplemented',
          message:
              'Secure screen is not available on this platform: ${error.message}',
          type: AppErrorType.unsupportedPlatform,
          isRetryable: false,
        ),
      );
    } on PlatformException catch (error) {
      return Left(
        AppErrorModel(
          code: 'secure_screen/platform_error',
          message: error.message ?? error.code,
          type: AppErrorType.unknown,
          isRetryable: false,
        ),
      );
    }
  }
}
