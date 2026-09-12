

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repos/lesson_quiz_repo.dart';
import 'package:dartz/dartz.dart';

class LessonQuizUseCase {
  final LessonQuizRepository lessonQuizRepo;

  LessonQuizUseCase({required this.lessonQuizRepo});

  Future<Either<AppErrorModel, List<LessonQuizEntity>>> getQuizQuestions({required String lessonId}) async {
    return await lessonQuizRepo.getQuizQuestions(lessonId:  lessonId);
  }
}