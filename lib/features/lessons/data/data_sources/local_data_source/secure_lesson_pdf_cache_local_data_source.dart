import 'dart:io';
import 'dart:typed_data';

import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/lesson_pdf_cache_local_data_source.dart';
import 'package:path_provider/path_provider.dart';

class SecureLessonPdfCacheLocalDataSource
    implements LessonPdfCacheLocalDataSource {
  const SecureLessonPdfCacheLocalDataSource();

  static const String _cacheDirectoryName = 'lessons_cache';
  static const String _cacheFileExtension = '.cache';
  static const String _temporaryFileExtension = '.tmp';

  @override
  Future<Uint8List?> getCachedPdf({
    required String lessonId,
    required DateTime updatedAt,
    required int expectedFileSize,
  }) async {
    final cacheFile = await _getCacheFile(
      lessonId: lessonId,
      updatedAt: updatedAt,
    );

    if (!await cacheFile.exists()) {
      return null;
    }

    try {
      final cachedBytes = await cacheFile.readAsBytes();

      final hasValidSize =
          expectedFileSize <= 0 ||
          cachedBytes.lengthInBytes == expectedFileSize;

      if (!hasValidSize) {
        await _deleteFileIfExists(cacheFile);
        return null;
      }

      return cachedBytes;
    } catch (_) {
      await _deleteFileIfExists(cacheFile);
      return null;
    }
  }

  @override
  Future<void> cachePdf({
    required String lessonId,
    required DateTime updatedAt,
    required Uint8List pdfBytes,
  }) async {
    _validatePdfBytes(pdfBytes);

    final cacheFile = await _getCacheFile(
      lessonId: lessonId,
      updatedAt: updatedAt,
    );

    final temporaryFile = File('${cacheFile.path}$_temporaryFileExtension');

    try {
      await temporaryFile.writeAsBytes(pdfBytes, flush: true);

      if (await cacheFile.exists()) {
        await cacheFile.delete();
      }

      await temporaryFile.rename(cacheFile.path);

      await deleteOldVersions(lessonId: lessonId, currentUpdatedAt: updatedAt);
    } finally {
      await _deleteFileIfExists(temporaryFile);
    }
  }

  @override
  Future<void> deleteOldVersions({
    required String lessonId,
    required DateTime currentUpdatedAt,
  }) async {
    final normalizedLessonId = _normalizeLessonId(lessonId);
    final cacheDirectory = await _getCacheDirectory();

    final currentFileName = _createCacheFileName(
      lessonId: normalizedLessonId,
      updatedAt: currentUpdatedAt,
    );

    final lessonFilePrefix = '${_sanitizeFileName(normalizedLessonId)}_';

    await for (final entity in cacheDirectory.list()) {
      if (entity is! File) {
        continue;
      }

      final fileName = _getFileName(entity.path);

      final belongsToCurrentLesson = fileName.startsWith(lessonFilePrefix);

      final isCurrentVersion = fileName == currentFileName;

      if (belongsToCurrentLesson && !isCurrentVersion) {
        await _deleteFileIfExists(entity);
      }
    }
  }

  @override
  Future<void> clearCache() async {
    final cacheDirectory = await _getCacheDirectory(createIfMissing: false);

    if (await cacheDirectory.exists()) {
      await cacheDirectory.delete(recursive: true);
    }
  }

  Future<File> _getCacheFile({
    required String lessonId,
    required DateTime updatedAt,
  }) async {
    final normalizedLessonId = _normalizeLessonId(lessonId);
    final cacheDirectory = await _getCacheDirectory();

    final fileName = _createCacheFileName(
      lessonId: normalizedLessonId,
      updatedAt: updatedAt,
    );

    return File(
      '${cacheDirectory.path}'
      '${Platform.pathSeparator}'
      '$fileName',
    );
  }

  Future<Directory> _getCacheDirectory({bool createIfMissing = true}) async {
    final applicationDirectory = await getApplicationSupportDirectory();

    final cacheDirectory = Directory(
      '${applicationDirectory.path}'
      '${Platform.pathSeparator}'
      '$_cacheDirectoryName',
    );

    if (createIfMissing && !await cacheDirectory.exists()) {
      await cacheDirectory.create(recursive: true);
    }

    return cacheDirectory;
  }

  String _createCacheFileName({
    required String lessonId,
    required DateTime updatedAt,
  }) {
    final sanitizedLessonId = _sanitizeFileName(lessonId);

    final version = updatedAt.toUtc().millisecondsSinceEpoch;

    return '${sanitizedLessonId}_$version'
        '$_cacheFileExtension';
  }

  String _normalizeLessonId(String lessonId) {
    final normalizedLessonId = lessonId.trim();

    if (normalizedLessonId.isEmpty) {
      FirebaseErrorHandler.throwStorageCode('invalid-argument');
    }

    return normalizedLessonId;
  }

  void _validatePdfBytes(Uint8List pdfBytes) {
    if (pdfBytes.isEmpty) {
      FirebaseErrorHandler.throwStorageCode('invalid-argument');
    }
  }

  String _sanitizeFileName(String value) {
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }

  String _getFileName(String filePath) {
    return filePath.split(Platform.pathSeparator).last;
  }

  Future<void> _deleteFileIfExists(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  @override
  Future<Uint8List?> getLatestCachedPdf({required String lessonId}) async {
    final normalizedLessonId = _normalizeLessonId(lessonId);

    final cacheDirectory = await _getCacheDirectory(createIfMissing: false);

    if (!await cacheDirectory.exists()) {
      return null;
    }

    final lessonFilePrefix = '${_sanitizeFileName(normalizedLessonId)}_';

    final cachedFiles = <File>[];

    await for (final entity in cacheDirectory.list()) {
      if (entity is! File) {
        continue;
      }

      final fileName = _getFileName(entity.path);

      final isLessonCacheFile =
          fileName.startsWith(lessonFilePrefix) &&
          fileName.endsWith(_cacheFileExtension);

      if (isLessonCacheFile) {
        cachedFiles.add(entity);
      }
    }

    if (cachedFiles.isEmpty) {
      return null;
    }

    cachedFiles.sort((first, second) {
      return second.path.compareTo(first.path);
    });

    for (final cacheFile in cachedFiles) {
      try {
        final cachedBytes = await cacheFile.readAsBytes();

        if (cachedBytes.isNotEmpty) {
          return cachedBytes;
        }

        await _deleteFileIfExists(cacheFile);
      } catch (_) {
        await _deleteFileIfExists(cacheFile);
      }
    }

    return null;
  }
}