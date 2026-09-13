import 'package:al_waleed/features/exams/domain/entities/student_exam_answer_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';

class CachedExamAttemptEntity {
  const CachedExamAttemptEntity({
    required this.resultId,
    required this.examId,
    required this.questionIds,
    required this.selectedChoiceIndexes,
    required this.startedAt,
    required this.expiresAt,
    required this.isTimeExpired,
    required this.isPendingSubmission,
    required this.updatedAt,
  });

  final String resultId;
  final String examId;
  final List<String> questionIds;
  final Map<String, int> selectedChoiceIndexes;
  final DateTime startedAt;
  final DateTime expiresAt;
  final bool isTimeExpired;
  final bool isPendingSubmission;
  final DateTime updatedAt;

  int get answeredQuestionsCount {
    return selectedChoiceIndexes.length;
  }

  int get unansweredQuestionsCount {
    final int count = questionIds.length - answeredQuestionsCount;

    return count < 0 ? 0 : count;
  }

  int? selectedChoiceFor(String questionId) {
    return selectedChoiceIndexes[questionId.trim()];
  }

  SubmitStudentExamEntity toSubmission({required bool isAutomatic}) {
    final List<StudentExamAnswerEntity> answers = selectedChoiceIndexes.entries
        .map((MapEntry<String, int> entry) {
          return StudentExamAnswerEntity(
            questionId: entry.key,
            selectedChoiceIndex: entry.value,
          );
        })
        .toList(growable: false);

    return SubmitStudentExamEntity(
      examId: examId,
      resultId: resultId,
      answers: List<StudentExamAnswerEntity>.unmodifiable(answers),
      isAutomatic: isAutomatic,
    );
  }

  CachedExamAttemptEntity copyWith({
    List<String>? questionIds,
    Map<String, int>? selectedChoiceIndexes,
    bool? isTimeExpired,
    bool? isPendingSubmission,
    DateTime? updatedAt,
  }) {
    return CachedExamAttemptEntity(
      resultId: resultId,
      examId: examId,
      questionIds: questionIds ?? this.questionIds,
      selectedChoiceIndexes:
          selectedChoiceIndexes ?? this.selectedChoiceIndexes,
      startedAt: startedAt,
      expiresAt: expiresAt,
      isTimeExpired: isTimeExpired ?? this.isTimeExpired,
      isPendingSubmission: isPendingSubmission ?? this.isPendingSubmission,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
