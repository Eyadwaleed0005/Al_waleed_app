class LessonQuizResultEntity {
  final int correctAnswersCount;
  final int totalQuestions;
  final int earnedScore;
  final int totalScore;

  const LessonQuizResultEntity({
    required this.correctAnswersCount,
    required this.totalQuestions,
    required this.earnedScore,
    required this.totalScore,
  });

  double get percentage {
    if (totalScore == 0) {
      return 0;
    }

    return earnedScore / totalScore;
  }

  bool get isPassing => percentage >= 0.5;
}