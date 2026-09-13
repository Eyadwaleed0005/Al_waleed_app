part of 'exams_screen_cubit.dart';

sealed class ExamsScreenState {
  const ExamsScreenState();
}

final class ExamsScreenInitial extends ExamsScreenState {
  const ExamsScreenInitial();
}

final class ExamsScreenLoading extends ExamsScreenState {
  const ExamsScreenLoading();
}

final class ExamsScreenSuccess extends ExamsScreenState {
  const ExamsScreenSuccess({required this.exams});

  final List<StudentExamListItemEntity> exams;
}

final class ExamsScreenEmpty extends ExamsScreenState {
  const ExamsScreenEmpty();
}

final class ExamsScreenFailure extends ExamsScreenState {
  const ExamsScreenFailure({required this.error});

  final AppErrorModel error;
}

final class ExamsScreenOpeningExam extends ExamsScreenState {
  const ExamsScreenOpeningExam({required this.exams, required this.examId});

  final List<StudentExamListItemEntity> exams;
  final String examId;
}

final class ExamsScreenSessionReady extends ExamsScreenState {
  const ExamsScreenSessionReady({required this.exams, required this.session});

  final List<StudentExamListItemEntity> exams;
  final StudentExamSessionEntity session;
}

final class ExamsScreenActionFailure extends ExamsScreenState {
  const ExamsScreenActionFailure({required this.exams, required this.error});

  final List<StudentExamListItemEntity> exams;
  final AppErrorModel error;
}
