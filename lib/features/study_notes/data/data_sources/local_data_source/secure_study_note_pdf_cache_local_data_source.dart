import 'dart:io';
import 'dart:typed_data';

import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/study_note_pdf_cache_local_data_source.dart';
import 'package:path_provider/path_provider.dart';

class SecureStudyNotePdfCacheLocalDataSource
    implements StudyNotePdfCacheLocalDataSource {
  const SecureStudyNotePdfCacheLocalDataSource();

  static const String _cacheDirectoryName = 'study_notes_cache';
  static const String _cacheFileExtension = '.cache';
  static const String _temporaryFileExtension = '.tmp';

  @override
  Future<Uint8List?> getCachedPdf({
    required String noteId,
    required DateTime updatedAt,
    required int expectedFileSize,
  }) async {
    final cacheFile = await _getCacheFile(noteId: noteId, updatedAt: updatedAt);

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
    required String noteId,
    required DateTime updatedAt,
    required Uint8List pdfBytes,
  }) async {
    _validatePdfBytes(pdfBytes);

    final cacheFile = await _getCacheFile(noteId: noteId, updatedAt: updatedAt);

    final temporaryFile = File('${cacheFile.path}$_temporaryFileExtension');

    try {
      await temporaryFile.writeAsBytes(pdfBytes, flush: true);

      if (await cacheFile.exists()) {
        await cacheFile.delete();
      }

      await temporaryFile.rename(cacheFile.path);

      await deleteOldVersions(noteId: noteId, currentUpdatedAt: updatedAt);
    } finally {
      await _deleteFileIfExists(temporaryFile);
    }
  }

  @override
  Future<void> deleteOldVersions({
    required String noteId,
    required DateTime currentUpdatedAt,
  }) async {
    final normalizedNoteId = _normalizeNoteId(noteId);
    final cacheDirectory = await _getCacheDirectory();

    final currentFileName = _createCacheFileName(
      noteId: normalizedNoteId,
      updatedAt: currentUpdatedAt,
    );

    final noteFilePrefix = '${_sanitizeFileName(normalizedNoteId)}_';

    await for (final entity in cacheDirectory.list()) {
      if (entity is! File) {
        continue;
      }

      final fileName = _getFileName(entity.path);

      final belongsToCurrentNote = fileName.startsWith(noteFilePrefix);

      final isCurrentVersion = fileName == currentFileName;

      if (belongsToCurrentNote && !isCurrentVersion) {
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
    required String noteId,
    required DateTime updatedAt,
  }) async {
    final normalizedNoteId = _normalizeNoteId(noteId);
    final cacheDirectory = await _getCacheDirectory();

    final fileName = _createCacheFileName(
      noteId: normalizedNoteId,
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
    required String noteId,
    required DateTime updatedAt,
  }) {
    final sanitizedNoteId = _sanitizeFileName(noteId);

    final version = updatedAt.toUtc().millisecondsSinceEpoch;

    return '${sanitizedNoteId}_$version'
        '$_cacheFileExtension';
  }

  String _normalizeNoteId(String noteId) {
    final normalizedNoteId = noteId.trim();

    if (normalizedNoteId.isEmpty) {
      FirebaseErrorHandler.throwStorageCode('invalid-argument');
    }

    return normalizedNoteId;
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
  Future<Uint8List?> getLatestCachedPdf({required String noteId}) async {
    final normalizedNoteId = _normalizeNoteId(noteId);

    final cacheDirectory = await _getCacheDirectory(createIfMissing: false);

    if (!await cacheDirectory.exists()) {
      return null;
    }

    final noteFilePrefix = '${_sanitizeFileName(normalizedNoteId)}_';

    final cachedFiles = <File>[];

    await for (final entity in cacheDirectory.list()) {
      if (entity is! File) {
        continue;
      }

      final fileName = _getFileName(entity.path);

      final isNoteCacheFile =
          fileName.startsWith(noteFilePrefix) &&
          fileName.endsWith(_cacheFileExtension);

      if (isNoteCacheFile) {
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
