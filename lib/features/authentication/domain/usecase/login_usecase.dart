import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/authentication/domain/entity/login_entity.dart';
import 'package:al_waleed/features/authentication/domain/repositories/login_repo.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final LoginRepo repo;

  LoginUseCase({required this.repo});

  Future<Either<AppErrorModel, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    return await repo.login(email: email, password: password);
  }
}
