import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/security_screens/domain/repositories/secure_screen_repository.dart';
import 'package:dartz/dartz.dart';

class EnableSecureScreenUseCase {
  final SecureScreenRepository _repository;

  const EnableSecureScreenUseCase({
    required SecureScreenRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, void>> call() {
    return _repository.enableSecureScreen();
  }
}