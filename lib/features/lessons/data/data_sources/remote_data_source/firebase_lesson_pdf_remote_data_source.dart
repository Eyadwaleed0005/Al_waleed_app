import 'dart:typed_data';

import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/lesson_pdf_remote_data_source.dart';

class FirebaseLessonPdfRemoteDataSource
    implements LessonPdfRemoteDataSource {
  final StorageService _storageService;

  const FirebaseLessonPdfRemoteDataSource({
    required StorageService storageService,
  }) : _storageService = storageService;

  static const int _maxPdfSizeInBytes = 15 * 1024 * 1024;

  @override
  Future<Uint8List> getPdfBytes({
    required String storagePath,
    required int fileSize,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final normalizedStoragePath = storagePath.trim();
      if (normalizedStoragePath.isEmpty || fileSize <= 0) {
        FirebaseErrorHandler.throwStorageCode('invalid-argument');
      }
      if (fileSize > _maxPdfSizeInBytes) {
        FirebaseErrorHandler.throwStorageCode('file-too-large');
      }
      return _storageService.getFileData(
        storagePath: normalizedStoragePath,
        maxSize: _maxPdfSizeInBytes,
      );
    });
  }
}