import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/app_startup/domain/repositories/app_startup_repository.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:dartz/dartz.dart';

class CheckStudyNoteAccessUseCase {
  const CheckStudyNoteAccessUseCase({required AppStartupRepository repository})
    : _repository = repository;

  final AppStartupRepository _repository;

  Future<Either<AppErrorModel, bool>> checkSubscription() async {
    final studentId = _repository.getCurrentUserId();

    if (studentId == null || studentId.trim().isEmpty) {
      return const Right(false);
    }

    final result = await _repository.getStudentAccess(
      studentId: studentId.trim(),
    );

    return result.map((studentAccess) => studentAccess.isActive);
  }

  Future<Either<AppErrorModel, bool>> call({
    required StudyNoteEntity studyNote,
  }) async {
    if (studyNote.isFree) {
      return const Right(true);
    }

    return checkSubscription();
  }
}
