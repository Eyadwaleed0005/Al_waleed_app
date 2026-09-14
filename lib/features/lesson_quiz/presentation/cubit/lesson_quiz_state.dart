part of 'lesson_quiz_cubit.dart';

sealed class LessonQuizState {
  const LessonQuizState();
}

final class LessonQuizInitial extends LessonQuizState {
  const LessonQuizInitial();
}

final class LessonQuizLoading extends LessonQuizState {
  const LessonQuizLoading();
}

final class LessonQuizSuccess extends LessonQuizState {
  final LessonQuizEntity quiz;

  const LessonQuizSuccess({required this.quiz});
}

final class LessonQuizFailure extends LessonQuizState {
  final AppErrorModel error;

  const LessonQuizFailure({required this.error});
}
