import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';
import 'package:dartz/dartz.dart';

class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileDataSource _dataSource;

  const StudentProfileRepositoryImpl({
    required StudentProfileDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Stream<Either<AppErrorModel, ProfileEntity>> streamStudentProfile() async* {
    try {
      await for (final profileModel in _dataSource.streamStudentProfile()) {
        yield Right(profileModel.toEntity());
      }
    } catch (error) {
      yield Left(FirebaseErrorHandler.handle(error));
    }
  }
}
