class LessonEntity {
  const LessonEntity({
    required this.lessonId,
    required this.title,
    required this.description,
    required this.gradeId,
    required this.isPublished,
    required this.youtubeUrl,
    required this.pdfStoragePath,
    required this.pdfFileName,
    required this.pdfFileSize,
    this.createdAt,
    this.updatedAt,
  });

  final String lessonId;
  final String title;
  final String description;
  final String gradeId;
  final bool isPublished;
  final String youtubeUrl;
  final String pdfStoragePath;
  final String pdfFileName;
  final int pdfFileSize;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
