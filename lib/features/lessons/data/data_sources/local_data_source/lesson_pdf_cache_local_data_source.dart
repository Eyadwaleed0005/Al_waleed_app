import 'dart:typed_data';

abstract interface class LessonPdfCacheLocalDataSource {
  Future<Uint8List?> getCachedPdf({
    required String lessonId,
    required DateTime updatedAt,
    required int expectedFileSize,
  });

  Future<Uint8List?> getLatestCachedPdf({required String lessonId});

  Future<void> cachePdf({
    required String lessonId,
    required DateTime updatedAt,
    required Uint8List pdfBytes,
  });

  Future<void> deleteOldVersions({
    required String lessonId,
    required DateTime currentUpdatedAt,
  });

  Future<void> clearCache();
}