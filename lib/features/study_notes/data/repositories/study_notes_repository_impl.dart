import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/study_notes_local_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class StudyNotesRepositoryImpl implements StudyNotesRepository {
  final StudyNotesLocalDataSource localDataSource;
  final StudyNotesRemoteDataSource remoteDataSource;

  const StudyNotesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<AppErrorModel, StudyNoteEntity>> getStudyNoteById({
    required String noteId,
  }) async {
    final gradeResult = await _getRequiredGradeId();

    final gradeError = gradeResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (gradeError != null) {
      return Left(gradeError);
    }

    final gradeId = gradeResult.getOrElse(() => '');

    try {
      final note = await remoteDataSource.getStudyNoteById(
        noteId: noteId,
        gradeId: gradeId,
      );

      return Right(note);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Stream<Either<AppErrorModel, List<StudyNoteEntity>>>
  streamStudyNotes() async* {
    final gradeResult = await _getRequiredGradeId();

    final gradeError = gradeResult.fold<AppErrorModel?>(
      (error) => error,
      (_) => null,
    );

    if (gradeError != null) {
      yield Left(gradeError);
      return;
    }

    final gradeId = gradeResult.getOrElse(() => '');

    try {
      await for (final models in remoteDataSource.streamStudyNotes(
        gradeId: gradeId,
      )) {
        yield Right(_mapModelsToEntities(models));
      }
    } on FirebaseRemoteException catch (error) {
      yield Left(error.errorModel);
    } catch (error) {
      yield Left(FirebaseErrorHandler.handle(error));
    }
  }

  Future<Either<AppErrorModel, String>> _getRequiredGradeId() async {
    try {
      final storedGradeId = await localDataSource.getGradeId();
      final gradeId = storedGradeId?.trim() ?? '';

      if (gradeId.isEmpty) {
        return Left(LocalStorageErrorHandler.dataNotFound());
      }

      return Right(gradeId);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }

  List<StudyNoteEntity> _mapModelsToEntities(List<StudyNoteModel> models) {
    return List<StudyNoteEntity>.unmodifiable(models);
  }
}
