import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudyNotesUseCase {
  const GetStudyNotesUseCase({required this._repository});

  final StudyNotesRepository _repository;

  Future<Either<AppErrorModel, List<StudyNoteEntity>>> call({
    String? gradeId,
    bool? isPublished,
  }) {
    return _repository.getStudyNotes(
      gradeId: gradeId,
      isPublished: isPublished,
    );
  }
}
