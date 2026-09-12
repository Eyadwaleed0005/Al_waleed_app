import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/lesson_quiz_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lesson_quiz_state.dart';

class LessonQuizCubit extends Cubit<LessonQuizState> {
  final LessonQuizUseCase getLessonQuizUseCase;

  LessonQuizCubit({required this.getLessonQuizUseCase})
      : super(LessonQuizInitial());

  bool _isClosing = false;
  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> getQuizQuestions({required String lessonId}) async {
    if (!_canEmit) return;

    emit(LessonQuizLoading());

    final normalizedLessonId = lessonId.trim();

    final result = await getLessonQuizUseCase.getQuizQuestions(
    lessonId  : normalizedLessonId,
    );

    if (!_canEmit) return;

    result.fold(
      (failure) {
        if (!_canEmit) return;

        emit(LessonQuizFailure(errorMessage: failure.message));
      },
      (questions) {
        if (!_canEmit) return;

        if (questions.isEmpty) {
          emit(LessonQuizInitial());
          return;
        }

        emit(LessonQuizSuccess(
          questions: questions,
          currentIndex: 0,
          isSubmitted: false,
        ));
      },
    );
  }

  void selectAnswer({required int questionIndex, required int optionIndex}) {
    if (!_canEmit) return;

    final currentState = state;
    if (currentState is LessonQuizSuccess) {
      if (currentState.isSubmitted) return;

      final updatedQuestions = List<LessonQuizEntity>.from(currentState.questions);
      final currentQuestion = updatedQuestions[questionIndex];

      updatedQuestions[questionIndex] = LessonQuizEntity(
        lessonId: currentQuestion.lessonId,
        questionText: currentQuestion.questionText,
        questionImageUrl: currentQuestion.questionImageUrl,
        options: currentQuestion.options,
        correctOption: currentQuestion.correctOption,
        questionScore: currentQuestion.questionScore,
        selectedOption: optionIndex,
      );

      emit(LessonQuizSuccess(
        questions: updatedQuestions,
        currentIndex: currentState.currentIndex,
        isSubmitted: currentState.isSubmitted,
      ));
    }
  }

  void nextQuestion() {
    if (!_canEmit) return;

    final currentState = state;
    if (currentState is LessonQuizSuccess) {
      if (currentState.currentIndex < currentState.questions.length - 1) {
        emit(LessonQuizSuccess(
          questions: currentState.questions,
          currentIndex: currentState.currentIndex + 1,
          isSubmitted: currentState.isSubmitted,
        ));
      }
    }
  }

  void previousQuestion() {
    if (!_canEmit) return;

    final currentState = state;
    if (currentState is LessonQuizSuccess) {
      if (currentState.currentIndex > 0) {
        emit(LessonQuizSuccess(
          questions: currentState.questions,
          currentIndex: currentState.currentIndex - 1,
          isSubmitted: currentState.isSubmitted,
        ));
      }
    }
  }

  void submitQuiz() {
    if (!_canEmit) return;

    final currentState = state;
    if (currentState is LessonQuizSuccess) {
      emit(LessonQuizSuccess(
        questions: currentState.questions,
        currentIndex: currentState.currentIndex,
        isSubmitted: true,
      ));
    }
  }

  void restartQuiz() {
    if (!_canEmit) return;

    final currentState = state;
    if (currentState is LessonQuizSuccess) {
      final resetQuestions = currentState.questions.map((q) {
        return LessonQuizEntity(
          lessonId: q.lessonId,
          questionText: q.questionText,
          questionImageUrl: q.questionImageUrl,
          options: q.options,
          correctOption: q.correctOption,
          questionScore: q.questionScore,
          selectedOption: null,
        );
      }).toList();

      emit(LessonQuizSuccess(
        questions: resetQuestions,
        currentIndex: 0,
        isSubmitted: false,
      ));
    }
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;

    await super.close();
  }
}