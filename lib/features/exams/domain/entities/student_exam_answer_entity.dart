class StudentExamAnswerEntity {
  const StudentExamAnswerEntity({
    required this.questionId,
    required this.selectedChoiceIndex,
  });

  final String questionId;
  final int selectedChoiceIndex;

  bool get hasValidChoiceIndex {
    return selectedChoiceIndex >= 0 && selectedChoiceIndex <= 3;
  }
}
