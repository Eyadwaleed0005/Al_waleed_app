
part of 'lesson_quiz_cubit.dart';
sealed class LessonQuizState extends Equatable {
  const LessonQuizState();

  @override
  List<Object?> get props => [];
}

final class LessonQuizInitial extends LessonQuizState {}

final class LessonQuizLoading extends LessonQuizState {}


final class LessonQuizSuccess extends LessonQuizState {
  final List<LessonQuizEntity> questions;
  final int currentIndex;
  final bool isSubmitted;

  const LessonQuizSuccess({
    required this.questions,
    this.currentIndex = 0,
    this.isSubmitted = false,
  });

  @override
  List<Object?> get props => [questions, currentIndex, isSubmitted];
}

final class LessonQuizFailure extends LessonQuizState {
  final String errorMessage;

  const LessonQuizFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}