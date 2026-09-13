import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/app_startup/domain/entities/student_access_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/student_exams_repository.dart';
import 'package:dartz/dartz.dart';

class StreamAvailableExamsUseCase {
  const StreamAvailableExamsUseCase({
    required StudentExamsRepository repository,
  }) : _repository = repository;

  final StudentExamsRepository _repository;

  Stream<Either<AppErrorModel, List<StudentExamListItemEntity>>> call({
    required StudentAccessEntity studentAccess,
  }) {
    return _repository.streamAvailableExams(studentAccess: studentAccess);
  }
}
