import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/authentication/domain/entity/register_entity.dart';
import 'package:al_waleed/features/authentication/domain/repositories/register_student_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterStudentUseCase {
  const RegisterStudentUseCase({required this._repository});

  final RegisterStudentRepository _repository;

  Future<Either<AppErrorModel, RegisterEntity>> call({
    required String name,
    required String gradeId,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    return _repository.registerStudent(
      name: name,
      gradeId: gradeId,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}
