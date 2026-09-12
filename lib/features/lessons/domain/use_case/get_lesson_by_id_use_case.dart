import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class GetLessonByIdUseCase {
  final LessonsRepository _repository;

  const GetLessonByIdUseCase({required this._repository});

  Future<Either<AppErrorModel, LessonEntity>> call({
    required String lessonId,
  }) {
    return _repository.getLessonById(lessonId: lessonId);
  }
}