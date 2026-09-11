import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudyNoteByIdUseCase {
  final StudyNotesRepository _repository;

  const GetStudyNoteByIdUseCase({required this._repository});

  Future<Either<AppErrorModel, StudyNoteEntity>> call({
    required String noteId,
  }) {
    return _repository.getStudyNoteById(noteId: noteId);
  }
}
