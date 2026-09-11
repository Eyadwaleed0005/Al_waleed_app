import 'dart:typed_data';

enum StudyNotePdfSource { cache, staleCache, firebaseStorage }

class StudyNotePdfEntity {
  final Uint8List bytes;
  final StudyNotePdfSource source;

  const StudyNotePdfEntity({required this.bytes, required this.source});
}
