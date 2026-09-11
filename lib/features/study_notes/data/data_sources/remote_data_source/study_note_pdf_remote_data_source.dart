import 'dart:typed_data';

abstract interface class StudyNotePdfRemoteDataSource {
  Future<Uint8List> getPdfBytes({
    required String storagePath,
    required int fileSize,
  });
}