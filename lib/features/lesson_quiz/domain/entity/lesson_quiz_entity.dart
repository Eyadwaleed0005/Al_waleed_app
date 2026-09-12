
class LessonQuizEntity  {
  final String lessonId;
  final String questionText;
  final String? questionImageUrl;
  final List<String> options;
  final int correctOption;
  final int questionScore;
  final int? selectedOption;

  const LessonQuizEntity({
    required this.lessonId,
    required this.questionText,
    this.questionImageUrl,
    required this.options,
    required this.correctOption,
    required this.questionScore,
    this.selectedOption,
  });
}
