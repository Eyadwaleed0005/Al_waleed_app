import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class StreamLessonsUseCase {
  final LessonsRepository repository;

  const StreamLessonsUseCase({required this.repository});

  Stream<Either<AppErrorModel, List<LessonEntity>>> call() {
    return repository.streamLessons();
  }
}