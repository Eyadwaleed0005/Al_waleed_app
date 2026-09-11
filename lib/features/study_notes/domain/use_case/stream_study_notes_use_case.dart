import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class StreamStudyNotesUseCase {
  final StudyNotesRepository repository;

  const StreamStudyNotesUseCase({required this.repository});

  Stream<Either<AppErrorModel, List<StudyNoteEntity>>> call() {
    return repository.streamStudyNotes();
  }
}
