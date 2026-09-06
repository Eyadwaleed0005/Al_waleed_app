import 'package:al_waleed/features/lesson_quiz/domain/entities/lesson_quiz_entity.dart';

enum AnswerState {
  /// Not selected, not evaluated.
  neutral,

  /// Selected by the user during active answering (no correctness shown yet).
  selected,

  /// The answer is correct and was selected by the user (review only).
  correctSelected,

  /// The answer is correct but was NOT selected by the user (review only).
  correctUnselected,

  /// The answer was selected by the user but is incorrect (review only).
  incorrectSelected,
}

// ---------------------------------------------------------------------------
// Quiz Flow Phase
// ---------------------------------------------------------------------------

enum QuizPhase { question, result, review }

// ---------------------------------------------------------------------------
// Base State
// ---------------------------------------------------------------------------

abstract class LessonQuizState {
  const LessonQuizState();
}

// ---------------------------------------------------------------------------
// Concrete States
// ---------------------------------------------------------------------------

class LessonQuizInitial extends LessonQuizState {
  const LessonQuizInitial();
}

class LessonQuizLoading extends LessonQuizState {
  const LessonQuizLoading();
}

class LessonQuizFailure extends LessonQuizState {
  const LessonQuizFailure(this.message);

  final String message;
}

/// The main interactive state. A single class drives the question screen,
/// result screen, and review screen depending on [phase].
class LessonQuizActive extends LessonQuizState {
  const LessonQuizActive({
    required this.quiz,
    required this.phase,
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.reviewQuestionIndex = 0,
    this.score = 0,
    this.validationMessage,
  });

  /// The loaded quiz data.
  final LessonQuizEntity quiz;

  /// Which top-level screen is being shown.
  final QuizPhase phase;

  /// Index of the question currently being answered (question phase).
  final int currentQuestionIndex;

  /// Map from question id → user-selected answer text.
  final Map<String, String> selectedAnswers;

  /// Index of the question shown in the review screen.
  final int reviewQuestionIndex;

  /// Number of correct answers (populated after submission).
  final int score;

  /// Inline validation message shown when the user tries to advance without
  /// selecting an answer. Cleared when a selection is made.
  final String? validationMessage;

  // ------------------------------------------------------------------
  // Derived helpers
  // ------------------------------------------------------------------

  int get totalQuestions => quiz.questions.length;

  String? get selectedAnswerForCurrentQuestion => selectedAnswers[quiz.questions[currentQuestionIndex].id];

  String? get selectedAnswerForReviewQuestion => selectedAnswers[quiz.questions[reviewQuestionIndex].id];

  bool get isLastQuestion => currentQuestionIndex == totalQuestions - 1;

  bool get isFirstReviewQuestion => reviewQuestionIndex == 0;

  bool get isLastReviewQuestion => reviewQuestionIndex == totalQuestions - 1;

  double get scorePercentage => totalQuestions == 0 ? 0 : score / totalQuestions;

  LessonQuizActive copyWith({
    LessonQuizEntity? quiz,
    QuizPhase? phase,
    int? currentQuestionIndex,
    Map<String, String>? selectedAnswers,
    int? reviewQuestionIndex,
    int? score,
    Object? validationMessage = _sentinel,
  }) {
    return LessonQuizActive(
      quiz: quiz ?? this.quiz,
      phase: phase ?? this.phase,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      reviewQuestionIndex: reviewQuestionIndex ?? this.reviewQuestionIndex,
      score: score ?? this.score,
      validationMessage: identical(validationMessage, _sentinel) ? this.validationMessage : validationMessage as String?,
    );
  }
}

// Sentinel used to distinguish "not passed" from explicit null.
const Object _sentinel = Object();
