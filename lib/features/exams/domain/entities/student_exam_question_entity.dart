class StudentExamQuestionEntity {
  const StudentExamQuestionEntity({
    required this.questionId,
    required this.examId,
    required this.questionText,
    required this.choices,
    required this.degree,
    required this.questionOrder,
    this.questionImageUrl,
  });

  final String questionId;
  final String examId;
  final String questionText;
  final String? questionImageUrl;
  final List<String> choices;
  final int degree;
  final int questionOrder;

  bool get hasImage {
    return questionImageUrl?.trim().isNotEmpty == true;
  }

  bool get hasValidChoices {
    return choices.length == 4 &&
        choices.every((choice) => choice.trim().isNotEmpty);
  }
}
