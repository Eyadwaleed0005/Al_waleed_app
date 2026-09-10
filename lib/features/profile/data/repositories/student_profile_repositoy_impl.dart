import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';
import 'package:dartz/dartz.dart';

class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileDataSource dataSource;

  StudentProfileRepositoryImpl({required this.dataSource});

  @override
  Future<Either<AppErrorModel, ProfileEntity>> getStudentProfile() async {
    try {
      final model = await dataSource.getStudentProfile();

      return right(model.toEntity());
    } catch (e) {
      return left(FirebaseErrorHandler.handle(e));
    }
  }
}
