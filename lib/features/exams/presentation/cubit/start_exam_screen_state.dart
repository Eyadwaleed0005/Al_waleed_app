part of 'start_exam_screen_cubit.dart';

sealed class StartExamScreenState {
  const StartExamScreenState();
}

final class StartExamScreenInitial extends StartExamScreenState {
  const StartExamScreenInitial();
}

final class StartExamScreenLoading extends StartExamScreenState {
  const StartExamScreenLoading();
}

sealed class StartExamScreenDataState extends StartExamScreenState {
  const StartExamScreenDataState({
    required this.session,
    required this.cachedAttempt,
    required this.currentQuestionIndex,
    required this.remainingDuration,
  });

  final StudentExamSessionEntity session;
  final CachedExamAttemptEntity cachedAttempt;
  final int currentQuestionIndex;
  final Duration remainingDuration;

  StudentExamQuestionEntity get currentQuestion {
    return session.questions[currentQuestionIndex];
  }

  int? selectedChoiceIndexFor(String questionId) {
    return cachedAttempt.selectedChoiceFor(questionId);
  }

  int get answeredQuestionsCount {
    return cachedAttempt.answeredQuestionsCount;
  }

  int get totalQuestionsCount {
    return session.questions.length;
  }

  bool get isFirstQuestion {
    return currentQuestionIndex == 0;
  }

  bool get isLastQuestion {
    return currentQuestionIndex == totalQuestionsCount - 1;
  }

  bool get isTimeExpired {
    return remainingDuration == Duration.zero;
  }

  int get completionPercentage {
    if (totalQuestionsCount == 0) {
      return 0;
    }

    return (((currentQuestionIndex + 1) / totalQuestionsCount) * 100).round();
  }
}

final class StartExamScreenReady extends StartExamScreenDataState {
  const StartExamScreenReady({
    required super.session,
    required super.cachedAttempt,
    required super.currentQuestionIndex,
    required super.remainingDuration,
  });
}

final class StartExamScreenSubmitting extends StartExamScreenDataState {
  const StartExamScreenSubmitting({
    required super.session,
    required super.cachedAttempt,
    required super.currentQuestionIndex,
    required super.remainingDuration,
    required this.isAutomatic,
  });

  final bool isAutomatic;
}

final class StartExamScreenResultReady extends StartExamScreenState {
  const StartExamScreenResultReady({required this.result});

  final StudentExamResultEntity result;
}

final class StartExamScreenFailure extends StartExamScreenState {
  const StartExamScreenFailure({required this.error});

  final AppErrorModel error;
}

final class StartExamScreenActionFailure extends StartExamScreenDataState {
  const StartExamScreenActionFailure({
    required super.session,
    required super.cachedAttempt,
    required super.currentQuestionIndex,
    required super.remainingDuration,
    required this.error,
    required this.isSubmissionFailure,
  });

  final AppErrorModel error;
  final bool isSubmissionFailure;
}
