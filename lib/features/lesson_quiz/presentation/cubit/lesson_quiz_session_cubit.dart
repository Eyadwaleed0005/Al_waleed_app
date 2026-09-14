import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_question_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_result_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/calculate_lesson_quiz_result_use_case.dart';
import 'package:bloc/bloc.dart';

part 'lesson_quiz_session_state.dart';

class LessonQuizSessionCubit extends Cubit<LessonQuizSessionState> {
  LessonQuizSessionCubit({
    required LessonQuizEntity quiz,
    required CalculateLessonQuizResultUseCase calculateResultUseCase,
  }) : _calculateResultUseCase = calculateResultUseCase,
       super(
         LessonQuizSessionState(
           quiz: quiz,
           currentIndex: 0,
           selectedAnswers: const {},
           isSubmitted: false,
         ),
       );

  final CalculateLessonQuizResultUseCase _calculateResultUseCase;

  void selectAnswer({required String questionId, required int optionIndex}) {
    if (state.isSubmitted) {
      return;
    }

    final questionIndex = state.quiz.questions.indexWhere(
      (question) => question.questionId == questionId,
    );

    if (questionIndex == -1) {
      return;
    }

    final question = state.quiz.questions[questionIndex];

    if (optionIndex < 0 || optionIndex >= question.options.length) {
      return;
    }

    final updatedAnswers = Map<String, int>.from(state.selectedAnswers);

    updatedAnswers[questionId] = optionIndex;

    emit(state.copyWith(selectedAnswers: updatedAnswers));
  }

  void nextQuestion() {
    if (state.isSubmitted ||
        !state.isCurrentQuestionAnswered ||
        state.isLastQuestion) {
      return;
    }

    emit(state.copyWith(currentIndex: state.currentIndex + 1));
  }

  void previousQuestion() {
    if (state.isSubmitted || state.isFirstQuestion) {
      return;
    }

    emit(state.copyWith(currentIndex: state.currentIndex - 1));
  }

  void submitQuiz() {
    if (state.isSubmitted || !state.areAllQuestionsAnswered) {
      return;
    }

    final result = _calculateResultUseCase(
      quiz: state.quiz,
      selectedAnswers: state.selectedAnswers,
    );

    emit(state.copyWith(isSubmitted: true, result: result));
  }

  void restartQuiz() {
    emit(
      LessonQuizSessionState(
        quiz: state.quiz,
        currentIndex: 0,
        selectedAnswers: const {},
        isSubmitted: false,
      ),
    );
  }
}
