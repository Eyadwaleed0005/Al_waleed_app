import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class StudentGradeRepository {
  Stream<Either<AppErrorModel, String>> streamStudentGradeId();
}