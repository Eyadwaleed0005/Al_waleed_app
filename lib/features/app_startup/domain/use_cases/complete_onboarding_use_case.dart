import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/app_startup/domain/repositories/app_startup_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase({required AppStartupRepository repository})
    : _repository = repository;

  final AppStartupRepository _repository;

  Future<Either<AppErrorModel, Unit>> call() {
    return _repository.completeOnboarding();
  }
}
