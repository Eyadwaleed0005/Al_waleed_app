import 'dart:typed_data';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/study_note_pdf_cache_local_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/study_note_pdf_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_pdf_entity.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_note_pdf_repository.dart';
import 'package:dartz/dartz.dart';

class StudyNotePdfRepositoryImpl implements StudyNotePdfRepository {
  final StudyNotePdfCacheLocalDataSource cacheLocalDataSource;
  final StudyNotePdfRemoteDataSource remoteDataSource;

  const StudyNotePdfRepositoryImpl({
    required this.cacheLocalDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<AppErrorModel, StudyNotePdfEntity>> getStudyNotePdf({
    required StudyNoteEntity note,
  }) async {
    final currentCachedPdf = await _getCurrentCachedPdf(note);

    if (currentCachedPdf != null) {
      return Right(
        StudyNotePdfEntity(
          bytes: currentCachedPdf,
          source: StudyNotePdfSource.cache,
        ),
      );
    }

    try {
      final pdfBytes = await remoteDataSource.getPdfBytes(
        storagePath: note.pdfStoragePath,
        fileSize: note.pdfFileSize,
      );

      await _cachePdf(note: note, pdfBytes: pdfBytes);

      return Right(
        StudyNotePdfEntity(
          bytes: pdfBytes,
          source: StudyNotePdfSource.firebaseStorage,
        ),
      );
    } on FirebaseRemoteException catch (error) {
      return _getStaleCacheOrFailure(note: note, error: error.errorModel);
    } catch (error) {
      return _getStaleCacheOrFailure(
        note: note,
        error: FirebaseErrorHandler.handle(error),
      );
    }
  }

  Future<Either<AppErrorModel, StudyNotePdfEntity>> _getStaleCacheOrFailure({
    required StudyNoteEntity note,
    required AppErrorModel error,
  }) async {
    final staleCachedPdf = await _getLatestCachedPdf(noteId: note.noteId);

    if (staleCachedPdf != null) {
      return Right(
        StudyNotePdfEntity(
          bytes: staleCachedPdf,
          source: StudyNotePdfSource.staleCache,
        ),
      );
    }

    return Left(error);
  }

  Future<Uint8List?> _getCurrentCachedPdf(StudyNoteEntity note) async {
    final updatedAt = note.updatedAt;

    if (updatedAt == null) {
      return null;
    }

    try {
      return await cacheLocalDataSource.getCachedPdf(
        noteId: note.noteId,
        updatedAt: updatedAt,
        expectedFileSize: note.pdfFileSize,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> _getLatestCachedPdf({required String noteId}) async {
    try {
      return await cacheLocalDataSource.getLatestCachedPdf(noteId: noteId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cachePdf({
    required StudyNoteEntity note,
    required Uint8List pdfBytes,
  }) async {
    final updatedAt = note.updatedAt;

    if (updatedAt == null) {
      return;
    }

    try {
      await cacheLocalDataSource.cachePdf(
        noteId: note.noteId,
        updatedAt: updatedAt,
        pdfBytes: pdfBytes,
      );
    } catch (_) {}
  }

  @override
  Future<void> clearPdfCache() async {
    try {
      await cacheLocalDataSource.clearCache();
    } catch (_) {}
  }
}
