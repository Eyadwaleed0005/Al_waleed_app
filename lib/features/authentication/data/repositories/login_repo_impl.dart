import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/domain/entity/login_entity.dart';
import 'package:al_waleed/features/authentication/domain/repositories/login_repo.dart';
import 'package:dartz/dartz.dart';

class LoginRepoImpl implements LoginRepo {
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepoImpl({required this.loginRemoteDataSource});
  @override
  Future<Either<AppErrorModel, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await loginRemoteDataSource.login(
        email: email,
        password: password,
      );
      return right(user);
    } on FirebaseRemoteException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(FirebaseErrorHandler.handle(e));
    }
  }
}
