import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_auth_error_handler.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/register_remote_data_source.dart';
import 'package:al_waleed/features/authentication/domain/entity/register_entity.dart';
import 'package:al_waleed/features/authentication/domain/repositories/register_student_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterStudentRepositoryImpl implements RegisterStudentRepository {
  const RegisterStudentRepositoryImpl({
    required RegisterRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final RegisterRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppErrorModel, RegisterEntity>> registerStudent({
    required String name,
    required String gradeId,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final student = await _remoteDataSource.registerStudent(
        name: name,
        gradeId: gradeId,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      return Right(student);
    } on FirebaseAuthException catch (error) {
      return Left(FirebaseAuthErrorHandler.handle(error));
    } on AppErrorModel catch (error) {
      return Left(error);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }
}
