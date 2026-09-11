import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_pdf_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_note_pdf_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudyNotePdfUseCase {
  final StudyNotePdfRepository _repository;

  const GetStudyNotePdfUseCase({
    required StudyNotePdfRepository repository,
  }) : _repository = repository;

  Future<Either<AppErrorModel, StudyNotePdfEntity>> call({
    required StudyNoteEntity note,
  }) {
    return _repository.getStudyNotePdf(
      note: note,
    );
  }
}