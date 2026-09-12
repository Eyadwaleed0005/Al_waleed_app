import 'dart:typed_data';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/lesson_pdf_cache_local_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/lesson_pdf_remote_data_source.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_pdf_entity.dart';
import 'package:al_waleed/features/lessons/domain/repositories/lesson_pdf_repository.dart';
import 'package:dartz/dartz.dart';

class LessonPdfRepositoryImpl implements LessonPdfRepository {
  final LessonPdfCacheLocalDataSource cacheLocalDataSource;
  final LessonPdfRemoteDataSource remoteDataSource;

  const LessonPdfRepositoryImpl({
    required this.cacheLocalDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<AppErrorModel, LessonPdfEntity>> getLessonPdf({
    required LessonEntity lesson,
  }) async {
    final currentCachedPdf = await _getCurrentCachedPdf(lesson);

    if (currentCachedPdf != null) {
      return Right(
        LessonPdfEntity(
          bytes: currentCachedPdf,
          source: LessonPdfSource.cache,
        ),
      );
    }

    try {
      final pdfBytes = await remoteDataSource.getPdfBytes(
        storagePath: lesson.pdfStoragePath,
        fileSize: lesson.pdfFileSize,
      );

      await _cachePdf(lesson: lesson, pdfBytes: pdfBytes);

      return Right(
        LessonPdfEntity(
          bytes: pdfBytes,
          source: LessonPdfSource.firebaseStorage,
        ),
      );
    } on FirebaseRemoteException catch (error) {
      return _getStaleCacheOrFailure(lesson: lesson, error: error.errorModel);
    } catch (error) {
      return _getStaleCacheOrFailure(
        lesson: lesson,
        error: FirebaseErrorHandler.handle(error),
      );
    }
  }

  Future<Either<AppErrorModel, LessonPdfEntity>> _getStaleCacheOrFailure({
    required LessonEntity lesson,
    required AppErrorModel error,
  }) async {
    final staleCachedPdf = await _getLatestCachedPdf(lessonId: lesson.lessonId);

    if (staleCachedPdf != null) {
      return Right(
        LessonPdfEntity(
          bytes: staleCachedPdf,
          source: LessonPdfSource.staleCache,
        ),
      );
    }

    return Left(error);
  }

  Future<Uint8List?> _getCurrentCachedPdf(LessonEntity lesson) async {
    final updatedAt = lesson.updatedAt;

    if (updatedAt == null) {
      return null;
    }

    try {
      return await cacheLocalDataSource.getCachedPdf(
        lessonId: lesson.lessonId,
        updatedAt: updatedAt,
        expectedFileSize: lesson.pdfFileSize,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> _getLatestCachedPdf({required String lessonId}) async {
    try {
      return await cacheLocalDataSource.getLatestCachedPdf(lessonId: lessonId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cachePdf({
    required LessonEntity lesson,
    required Uint8List pdfBytes,
  }) async {
    final updatedAt = lesson.updatedAt;

    if (updatedAt == null) {
      return;
    }

    try {
      await cacheLocalDataSource.cachePdf(
        lessonId: lesson.lessonId,
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