abstract final class FirestoreFields {
  const FirestoreFields._();

  // Relations

  static const String gradeId = 'gradeId';
  static const String studentId = 'studentId';
  static const String lessonId = 'lessonId';
  static const String examId = 'examId';
  static const String resultId = 'resultId';
  static const String questionId = 'questionId';

  // Common

  static const String name = 'name';
  static const String title = 'title';
  static const String description = 'description';

  static const String isActive = 'isActive';
  static const String isPublished = 'isPublished';
  static const String isDeleting = 'isDeleting';

  static const String status = 'status';
  static const String score = 'score';

  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';

  // Grades

  static const String displayOrder = 'displayOrder';

  // Students

  static const String email = 'email';
  static const String phoneNumber = 'phoneNumber';
  static const String age = 'age';

  static const String subscriptionStartAt = 'subscriptionStartAt';

  static const String subscriptionEndAt = 'subscriptionEndAt';

  static const String isLoggedIn = 'isLoggedIn';

  // Lessons

  static const String youtubeUrl = 'youtubeUrl';
  static const String pdfUrl = 'pdfUrl';

  // Study notes PDF

  static const String pdfStoragePath = 'pdfStoragePath';
  static const String pdfFileName = 'pdfFileName';
  static const String pdfFileSize = 'pdfFileSize';

  // Questions

  static const String questionText = 'questionText';

  static const String questionImageUrl = 'questionImageUrl';

  static const String questionImageStoragePath = 'questionImageStoragePath';

  static const String option1 = 'option1';
  static const String option2 = 'option2';
  static const String option3 = 'option3';
  static const String option4 = 'option4';

  static const String choices = 'choices';

  static const String correctOption = 'correctOption';
  static const String questionScore = 'questionScore';
  static const String questionOrder = 'questionOrder';

  // Exams

  static const String examName = 'examName';
  static const String questionCount = 'questionCount';
  static const String durationMinutes = 'durationMinutes';
  static const String totalScore = 'totalScore';

  static const String startAt = 'startAt';
  static const String endAt = 'endAt';

  static const String examStatus = 'examStatus';

  static const String firstAttemptAt = 'firstAttemptAt';
  static const String closedAt = 'closedAt';
  static const String participantsCount = 'participantsCount';

  // Exam results

  static const String studentName = 'studentName';
  static const String gradeName = 'gradeName';

  static const String studentScore = 'studentScore';
  static const String resultStatus = 'resultStatus';

  static const String startedAt = 'startedAt';
  static const String expiresAt = 'expiresAt';
  static const String submittedAt = 'submittedAt';

  static const String correctAnswers = 'correctAnswers';
  static const String wrongAnswers = 'wrongAnswers';

  static const String unansweredQuestions = 'unansweredQuestions';

  // Exam attempt answers

  static const String selectedChoiceIndex = 'selectedChoiceIndex';

  static const String isCorrect = 'isCorrect';
  static const String awardedScore = 'awardedScore';
  static const String answeredAt = 'answeredAt';

  // Live sessions

  static const String platformType = 'platformType';
  static const String meetingUrl = 'meetingUrl';

  // App version - Android

  static const String androidLatestVersion = 'androidLatestVersion';

  static const String androidLatestBuildNumber = 'androidLatestBuildNumber';

  static const String androidStoreUrl = 'androidStoreUrl';

  static const String androidForceUpdate = 'androidForceUpdate';

  // App version - iOS

  static const String iosLatestVersion = 'iosLatestVersion';

  static const String iosLatestBuildNumber = 'iosLatestBuildNumber';

  static const String iosStoreUrl = 'iosStoreUrl';

  static const String iosForceUpdate = 'iosForceUpdate';
}
