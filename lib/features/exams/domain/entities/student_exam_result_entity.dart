class StudentExamResultEntity {
  const StudentExamResultEntity({
    required this.resultId,
    required this.examId,
    required this.examName,
    required this.score,
    required this.totalScore,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unansweredQuestions,
    required this.submittedAt,
  });

  static const double minimumPassingPercentage = 50;

  final String resultId;
  final String examId;
  final String examName;
  final int score;
  final int totalScore;
  final int correctAnswers;
  final int wrongAnswers;
  final int unansweredQuestions;
  final DateTime submittedAt;

  bool get hasValidScore {
    return totalScore > 0 && score >= 0 && score <= totalScore;
  }

  double get percentage {
    if (!hasValidScore) {
      return 0;
    }

    return (score / totalScore) * 100;
  }

  bool get isPassed {
    return hasValidScore && percentage >= minimumPassingPercentage;
  }
}
