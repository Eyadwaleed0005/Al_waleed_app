import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/lesson_quiz_usecase.dart';
import 'package:bloc/bloc.dart';

part 'lesson_quiz_state.dart';

class LessonQuizCubit extends Cubit<LessonQuizState> {
  LessonQuizCubit({required GetLessonQuizUseCase getLessonQuizUseCase})
    : _getLessonQuizUseCase = getLessonQuizUseCase,
      super(LessonQuizInitial());

  final GetLessonQuizUseCase _getLessonQuizUseCase;

  Future<void> loadLessonQuiz({required String lessonId}) async {
    emit(LessonQuizLoading());

    final result = await _getLessonQuizUseCase(lessonId: lessonId);

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(LessonQuizFailure(error: error));
      },
      (quiz) {
        emit(LessonQuizSuccess(quiz: quiz));
      },
    );
  }
}
