class ExamQuestionEntity {
  const ExamQuestionEntity({
    required this.id,
    required this.questionText,
    required this.options,
    this.imageUrl,
    this.correctAnswerIndex,
  });

  final String id;
  final String questionText;
  final List<String> options;
  final String? imageUrl;
  final int? correctAnswerIndex;
}
