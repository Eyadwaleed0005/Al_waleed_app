import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_pdf_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class StudyNotePdfRepository {
  Future<Either<AppErrorModel, StudyNotePdfEntity>> getStudyNotePdf({
    required StudyNoteEntity note,
  });

  Future<void> clearPdfCache();
}