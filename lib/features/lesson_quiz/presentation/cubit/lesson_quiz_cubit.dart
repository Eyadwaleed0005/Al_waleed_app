import 'package:al_waleed/features/lesson_quiz/domain/use_cases/get_lesson_quiz_use_case.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonQuizCubit extends Cubit<LessonQuizState> {
  LessonQuizCubit(this._getLessonQuizUseCase) : super(const LessonQuizInitial());

  final GetLessonQuizUseCase _getLessonQuizUseCase;

  Future<void> loadQuiz() async {
    emit(const LessonQuizLoading());
    try {
      final quiz = await _getLessonQuizUseCase();
      emit(
        LessonQuizActive(
          quiz: quiz,
          phase: QuizPhase.question,
          selectedAnswers: const {},
        ),
      );
    } catch (e) {
      emit(LessonQuizFailure(e.toString()));
    }
  }

  /// User taps an answer option on the current question.
  void selectAnswer(String answer) {
    final current = _active;
    if (current == null) return;

    final questionId = current.quiz.questions[current.currentQuestionIndex].id;
    final updatedAnswers = Map<String, String>.from(current.selectedAnswers)..[questionId] = answer;

    emit(
      current.copyWith(
        selectedAnswers: updatedAnswers,
        validationMessage: null, // clear validation on selection
      ),
    );
  }

  /// User presses "التالي" to advance to next question.
  void nextQuestion() {
    final current = _active;
    if (current == null) return;

    if (current.selectedAnswerForCurrentQuestion == null) {
      emit(current.copyWith(validationMessage: 'من فضلك اختر إجابة أولاً'));
      return;
    }

    if (current.isLastQuestion) {
      _submitQuiz(current);
    } else {
      emit(current.copyWith(currentQuestionIndex: current.currentQuestionIndex + 1, validationMessage: null));
    }
  }

  /// User presses "السابق" to go back to the previous question.
  void previousQuestion() {
    final current = _active;
    if (current == null || current.currentQuestionIndex == 0) return;

    emit(current.copyWith(currentQuestionIndex: current.currentQuestionIndex - 1, validationMessage: null));
  }

  /// User presses "تسليم الاختبار" on the last question.
  void submitQuiz() {
    final current = _active;
    if (current == null) return;

    if (current.selectedAnswerForCurrentQuestion == null) {
      emit(current.copyWith(validationMessage: 'من فضلك اختر إجابة أولاً'));
      return;
    }

    _submitQuiz(current);
  }

  void _submitQuiz(LessonQuizActive current) {
    int correctCount = 0;
    for (final question in current.quiz.questions) {
      final selected = current.selectedAnswers[question.id];
      if (selected == question.correctAnswer) correctCount++;
    }
    emit(current.copyWith(phase: QuizPhase.result, score: correctCount, validationMessage: null));
  }

  /// User taps "مراجعة الإجابات" from the result screen.
  void startReview() {
    final current = _active;
    if (current == null) return;

    emit(current.copyWith(phase: QuizPhase.review, reviewQuestionIndex: 0));
  }

  /// User taps "إعادة الاختبار" — full reset back to Question 1.
  void retryQuiz() {
    final current = _active;
    if (current == null) return;

    emit(
      LessonQuizActive(
        quiz: current.quiz,
        phase: QuizPhase.question,
        currentQuestionIndex: 0,
        selectedAnswers: const {},
        reviewQuestionIndex: 0,
        score: 0,
      ),
    );
  }

  /// Advance to the next review question.
  void nextReviewQuestion() {
    final current = _active;
    if (current == null || current.isLastReviewQuestion) return;

    emit(current.copyWith(reviewQuestionIndex: current.reviewQuestionIndex + 1));
  }

  /// Go back to the previous review question.
  void previousReviewQuestion() {
    final current = _active;
    if (current == null || current.reviewQuestionIndex == 0) return;

    emit(current.copyWith(reviewQuestionIndex: current.reviewQuestionIndex - 1));
  }

  /// End the review and return to the result screen.
  void endReview() {
    final current = _active;
    if (current == null) return;

    emit(current.copyWith(phase: QuizPhase.result));
  }

  LessonQuizActive? get _active {
    final s = state;
    return s is LessonQuizActive ? s : null;
  }
}
