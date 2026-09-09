import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class StudyNotesRepositoryImpl implements StudyNotesRepository {
  const StudyNotesRepositoryImpl({required this._remoteDataSource});

  final StudyNotesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppErrorModel, List<StudyNoteEntity>>> getStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) async {
    try {
      final models = await _remoteDataSource.getStudyNotes(
        gradeId: gradeId,
        isPublished: isPublished,
      );

      return Right(_mapModelsToEntities(models));
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, StudyNoteEntity>> getStudyNoteById({
    required String noteId,
  }) async {
    try {
      final model = await _remoteDataSource.getStudyNoteById(noteId: noteId);

      return Right(model);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Stream<Either<AppErrorModel, List<StudyNoteEntity>>> streamStudyNotes({
    String? gradeId,
    bool? isPublished,
  }) async* {
    try {
      await for (final models in _remoteDataSource.streamStudyNotes(
        gradeId: gradeId,
        isPublished: isPublished,
      )) {
        yield Right(_mapModelsToEntities(models));
      }
    } on FirebaseRemoteException catch (error) {
      yield Left(error.errorModel);
    }
  }

  List<StudyNoteEntity> _mapModelsToEntities(List<StudyNoteModel> models) {
    return models
        .map<StudyNoteEntity>((model) => model)
        .toList(growable: false);
  }
}
