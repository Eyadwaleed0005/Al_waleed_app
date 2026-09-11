import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/main_navigation/domain/repositories/student_grade_repository.dart';
import 'package:dartz/dartz.dart';

class StreamStudentGradeIdUseCase {
  const StreamStudentGradeIdUseCase({
    required StudentGradeRepository repository,
  }) : _repository = repository;

  final StudentGradeRepository _repository;

  Stream<Either<AppErrorModel, String>> call() {
    return _repository.streamStudentGradeId();
  }
}