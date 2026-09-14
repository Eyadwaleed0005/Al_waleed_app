part of 'lesson_quiz_session_cubit.dart';

final class LessonQuizSessionState {
  final LessonQuizEntity quiz;
  final int currentIndex;
  final Map<String, int> selectedAnswers;
  final bool isSubmitted;
  final LessonQuizResultEntity? result;

  const LessonQuizSessionState({
    required this.quiz,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.isSubmitted,
    this.result,
  });

  bool get hasQuestions => quiz.questions.isNotEmpty;

  bool get isFirstQuestion => currentIndex == 0;

  bool get isLastQuestion {
    if (!hasQuestions) {
      return false;
    }

    return currentIndex == quiz.questions.length - 1;
  }

  LessonQuizQuestionEntity? get currentQuestion {
    if (!hasQuestions ||
        currentIndex < 0 ||
        currentIndex >= quiz.questions.length) {
      return null;
    }

    return quiz.questions[currentIndex];
  }

  int? get currentSelectedOption {
    final question = currentQuestion;

    if (question == null) {
      return null;
    }

    return selectedAnswers[question.questionId];
  }

  bool get isCurrentQuestionAnswered {
    return currentSelectedOption != null;
  }

  bool get areAllQuestionsAnswered {
    if (!hasQuestions) {
      return false;
    }

    return quiz.questions.every((question) {
      return selectedAnswers.containsKey(question.questionId);
    });
  }

  LessonQuizSessionState copyWith({
    LessonQuizEntity? quiz,
    int? currentIndex,
    Map<String, int>? selectedAnswers,
    bool? isSubmitted,
    LessonQuizResultEntity? result,
  }) {
    return LessonQuizSessionState(
      quiz: quiz ?? this.quiz,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: Map<String, int>.unmodifiable(
        selectedAnswers ?? this.selectedAnswers,
      ),
      isSubmitted: isSubmitted ?? this.isSubmitted,
      result: result ?? this.result,
    );
  }
}
