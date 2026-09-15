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
  late final String logoApp = '${baseImages}app_icon.png';
  late final String liveSessionBannerIllustration =
      '${baseImages}live_session_banner_illustration.png';
  late final String lessonTestTubes = '${baseImages}lesson_test_tubes.png';
  late final String alwaleedImg = '${baseImages}alwaleed_img.png';

  // ===== icons =====
  late final String homeIcon = '${baseIcons}Home.svg';
  late final String search = '${baseIcons}Search.svg';
  late final String bookOpen = '${baseIcons}BookOpen.svg';
  late final String bookOpenBig = '${baseIcons}BookOpenBig.svg';
  late final String exam = '${baseIcons}Exams.svg';
  late final String studyNotes = '${baseIcons}StudyNotes.svg';
  late final String readerPdf = '${baseIcons}PdfFile.svg';
  late final String emptyBookOpen = '${baseIcons}empty_book_open.svg';
  late final String emptyNotesIcon = '${baseIcons}empty_notes.svg';
  late final String profile = '${baseIcons}Profile.svg';
  late final String emptyExam = '${baseIcons}empty_exam.svg';
  // ===== animations =====
}
