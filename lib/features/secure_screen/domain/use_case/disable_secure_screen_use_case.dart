import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/secure_screen/domain/repositories/secure_screen_repository.dart';
import 'package:dartz/dartz.dart';

class DisableSecureScreenUseCase {
  const DisableSecureScreenUseCase({required this._repository});

  final SecureScreenRepository _repository;

  Future<Either<AppErrorModel, void>> call() {
    return _repository.disableSecureScreen();
  }
}
