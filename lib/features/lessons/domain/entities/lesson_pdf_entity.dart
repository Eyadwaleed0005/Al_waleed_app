import 'dart:typed_data';

enum LessonPdfSource { cache, staleCache, firebaseStorage }

class LessonPdfEntity {
  final Uint8List bytes;
  final LessonPdfSource source;

  const LessonPdfEntity({required this.bytes, required this.source});
}