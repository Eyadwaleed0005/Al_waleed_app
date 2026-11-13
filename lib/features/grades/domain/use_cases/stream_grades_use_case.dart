import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/grades/domain/entities/grade_entity.dart';
import 'package:al_waleed/features/grades/domain/repositories/grades_repository.dart';
import 'package:dartz/dartz.dart';

class StreamGradesUseCase {
  final GradesRepository _gradesRepository;

  const StreamGradesUseCase({required GradesRepository gradesRepository})
    : _gradesRepository = gradesRepository;

  Stream<Either<AppErrorModel, List<GradeEntity>>> call({
    bool activeOnly = true,
  }) {
    return _gradesRepository.streamGrades(activeOnly: activeOnly);
  }
}
