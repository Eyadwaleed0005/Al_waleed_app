import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/authentication/domain/entity/register_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class RegisterStudentRepository {
  Future<Either<AppErrorModel, RegisterEntity>> registerStudent({
    required String name,
    required String gradeId,
    required String email,
    required String phoneNumber,
    required String password,
  });
}
