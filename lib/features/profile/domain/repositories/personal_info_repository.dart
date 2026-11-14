import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/personal_info_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class PersonalInfoRepository {
  Future<Either<AppErrorModel, PersonalInfoEntity>> getPersonalInfo();

  Future<Either<AppErrorModel, Unit>> updatePersonalInfo({
    required String name,
    required String phoneNumber,
    required String email,
    String? currentPassword,
  });
}
