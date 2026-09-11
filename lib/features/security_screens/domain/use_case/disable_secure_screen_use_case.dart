import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/security_screens/domain/repositories/secure_screen_repository.dart';
import 'package:dartz/dartz.dart';

class DisableSecureScreenUseCase {
  final SecureScreenRepository _repository;

  const DisableSecureScreenUseCase({
    required SecureScreenRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, void>> call() {
    return _repository.disableSecureScreen();
  }
}