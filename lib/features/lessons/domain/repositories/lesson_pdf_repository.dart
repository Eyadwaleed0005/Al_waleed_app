import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_pdf_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class LessonPdfRepository {
  Future<Either<AppErrorModel, LessonPdfEntity>> getLessonPdf({
    required LessonEntity lesson,
  });

  Future<void> clearPdfCache();
}