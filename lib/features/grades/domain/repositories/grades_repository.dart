import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/grades/domain/entities/grade_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class GradesRepository {
  Future<Either<AppErrorModel, List<GradeEntity>>> getGrades({
    bool activeOnly = true,
  });

  Stream<Either<AppErrorModel, List<GradeEntity>>> streamGrades({
    bool activeOnly = true,
  });
}
