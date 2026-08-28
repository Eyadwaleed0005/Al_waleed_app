class AppImage {
  static AppImage? _instance;

  factory AppImage() {
    _instance ??= AppImage._internal();
    return _instance!;
  }

  AppImage._internal();

  // Base paths
  final String baseImages = 'assets/images/';
  final String baseAnimation = 'assets/animation/';
  final String baseIcons = 'assets/icons/';

  // ===== images =====
  late final String teacherBanner = '${baseImages}teacher_banner.png';
  late final String logoApp = '${baseImages}logo.png';

  // ===== icons =====
  late final String homeIcon = '${baseIcons}home.png';
  late final String search = '${baseIcons}search.png';
  late final String bookOpen = '${baseIcons}book_open.png';
  late final String bookOpenBig = '${baseIcons}BookOpenBig.png';
  late final String exam = '${baseIcons}exams.png';
  late final String studyNotes = '${baseIcons}study_notes.png';

  // ===== animations =====
}
