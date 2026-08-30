/// A single quiz question with its answer options and correct answer.
class QuizQuestionEntity {
  const QuizQuestionEntity({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    this.imageUrl,
  });

  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String? imageUrl;
}
