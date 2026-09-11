import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StudentProfileRepository {
  Future<Either<AppErrorModel, ProfileEntity>> getStudentProfile();
}
