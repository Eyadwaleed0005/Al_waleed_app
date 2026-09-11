import 'dart:typed_data';

abstract interface class StudyNotePdfCacheLocalDataSource {
  Future<Uint8List?> getCachedPdf({
    required String noteId,
    required DateTime updatedAt,
    required int expectedFileSize,
  });

  Future<Uint8List?> getLatestCachedPdf({required String noteId});

  Future<void> cachePdf({
    required String noteId,
    required DateTime updatedAt,
    required Uint8List pdfBytes,
  });

  Future<void> deleteOldVersions({
    required String noteId,
    required DateTime currentUpdatedAt,
  });

  Future<void> clearCache();
}
