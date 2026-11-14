import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/repositories/personal_info_repository.dart';
import 'package:dartz/dartz.dart';

class UpdatePersonalInfoUseCase {
  const UpdatePersonalInfoUseCase({required PersonalInfoRepository repository})
    : _repository = repository;

  final PersonalInfoRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String name,
    required String phoneNumber,
    required String email,
    String? currentPassword,
  }) {
    return _repository.updatePersonalInfo(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      currentPassword: currentPassword,
    );
  }
}
