import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/personal_info_entity.dart';
import 'package:al_waleed/features/profile/domain/repositories/personal_info_repository.dart';
import 'package:dartz/dartz.dart';

class GetPersonalInfoUseCase {
  const GetPersonalInfoUseCase({required PersonalInfoRepository repository})
    : _repository = repository;

  final PersonalInfoRepository _repository;

  Future<Either<AppErrorModel, PersonalInfoEntity>> call() {
    return _repository.getPersonalInfo();
  }
}
