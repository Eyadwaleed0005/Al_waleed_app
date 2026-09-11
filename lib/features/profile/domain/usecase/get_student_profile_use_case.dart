import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUseCase {
  final StudentProfileRepository studentProfileRepository;
  GetProfileUseCase({required this.studentProfileRepository});

  Future<Either<AppErrorModel, ProfileEntity>> call() async {
    return await studentProfileRepository.getStudentProfile();
  }
}
