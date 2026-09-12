import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/authentication/domain/repositories/logout_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final LogoutRepository _repository;

  const LogoutUseCase({
    required LogoutRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, void>> call() {
    return _repository.logout();
  }
}