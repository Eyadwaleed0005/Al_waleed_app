class LessonQuizQuestionEntity {
  final String questionId;
  final String questionText;
  final String? questionImageUrl;
  final List<String> options;
  final int correctOptionIndex;
  final int score;

  const LessonQuizQuestionEntity({
    required this.questionId,
    required this.questionText,
    this.questionImageUrl,
    required this.options,
    required this.correctOptionIndex,
    required this.score,
  });
}