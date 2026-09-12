import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';
import 'package:dartz/dartz.dart';

class StreamStudentProfileUseCase {
  final StudentProfileRepository _repository;

  const StreamStudentProfileUseCase({
    required StudentProfileRepository repository,
  }) : _repository = repository;

  Stream<Either<AppErrorModel, ProfileEntity>> call() {
    return _repository.streamStudentProfile();
  }
}