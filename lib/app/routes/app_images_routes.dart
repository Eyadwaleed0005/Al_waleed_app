class AppImage {
  static AppImage? _instance;

  factory AppImage() {
    _instance ??= AppImage._internal();
    return _instance!;
  }

  AppImage._internal();

  // ===== Base Paths =====
  final String baseImages = 'assets/images/';
  final String baseAnimation = 'assets/animation/';
  final String baseIcons = 'assets/icons/';

  // ===== Brand =====
  late final String logoApp = '${baseImages}app_icon.png';
  late final String alwaleedImg = '${baseImages}alwaleed_img.png';

  // ===== Onboarding =====
  late final String onboardingScience = '${baseImages}onboarding_science.svg';
  late final String onboardingRecordedLessons =
      '${baseImages}onboarding_recorded_lessons.svg';

  late final String onboardingLiveSessions =
      '${baseImages}onboarding_live_sessions.svg';

  // ===== Banners =====
  late final String teacherBanner = '${baseImages}teacher_banner.png';
  late final String liveSessionBannerIllustration =
      '${baseImages}live_session_banner_illustration.png';
  late final String aboutTeacherImage = '${baseImages}about_teacher.png';

  // ===== Lessons =====
  late final String lessonTestTubes = '${baseImages}lesson_test_tubes.png';
  late final String profileAvatar = '${baseImages}avatar_sage.svg';

  // ===== Navigation Icons =====
  late final String homeIcon = '${baseIcons}Home.svg';
  late final String search = '${baseIcons}Search.svg';
  late final String bookOpen = '${baseIcons}BookOpen.svg';
  late final String exam = '${baseIcons}Exams.svg';
  late final String studyNotes = '${baseIcons}StudyNotes.svg';
  late final String profile = '${baseIcons}Profile.svg';

  // ===== Content Icons =====
  late final String bookOpenBig = '${baseIcons}BookOpenBig.svg';
  late final String readerPdf = '${baseIcons}PdfFile.svg';

  // ===== Empty State Icons =====
  late final String emptyBookOpen = '${baseIcons}empty_book_open.svg';
  late final String emptyNotesIcon = '${baseIcons}empty_notes.svg';
  late final String emptyExam = '${baseIcons}empty_exam.svg';

  // ===== Animations =====
}
