import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/secure_screen/domain/use_case/disable_secure_screen_use_case.dart';
import 'package:al_waleed/features/secure_screen/domain/use_case/enable_secure_screen_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class SecureScreenService {
  const SecureScreenService({
    required this._enableSecureScreenUseCase,
    required this._disableSecureScreenUseCase,
  });

  final EnableSecureScreenUseCase _enableSecureScreenUseCase;
  final DisableSecureScreenUseCase _disableSecureScreenUseCase;

  Future<bool> enable() async {
    return _execute(_enableSecureScreenUseCase.call);
  }

  Future<bool> disable() async {
    return _execute(_disableSecureScreenUseCase.call);
  }

  Future<bool> _execute(
    Future<Either<AppErrorModel, void>> Function() operation,
  ) async {
    final result = await operation();

    return result.fold((error) {
      debugPrint(
        'SecureScreenService error: ${error.code} - ${error.message}',
      );

      return false;
    }, (_) => true);
  }
}
