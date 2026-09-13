import 'dart:async';

import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_answer_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_question_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/use_cases/get_cached_exam_attempt_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/save_exam_answer_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/submit_student_exam_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'start_exam_screen_state.dart';

class StartExamScreenCubit extends Cubit<StartExamScreenState> {
  StartExamScreenCubit({
    required GetCachedExamAttemptUseCase getCachedExamAttemptUseCase,
    required SaveExamAnswerUseCase saveExamAnswerUseCase,
    required SubmitStudentExamUseCase submitStudentExamUseCase,
  }) : _getCachedExamAttemptUseCase = getCachedExamAttemptUseCase,
       _saveExamAnswerUseCase = saveExamAnswerUseCase,
       _submitStudentExamUseCase = submitStudentExamUseCase,
       super(const StartExamScreenInitial());

  final GetCachedExamAttemptUseCase _getCachedExamAttemptUseCase;
  final SaveExamAnswerUseCase _saveExamAnswerUseCase;
  final SubmitStudentExamUseCase _submitStudentExamUseCase;

  Timer? _timer;

  StudentExamSessionEntity? _session;
  CachedExamAttemptEntity? _cachedAttempt;

  int _currentQuestionIndex = 0;

  bool _isInitializing = false;
  bool _isSubmitting = false;
  bool _hasHandledExpiration = false;

  Duration _remainingDuration = Duration.zero;

  Future<void> initialize({required StudentExamSessionEntity session}) async {
    if (_isInitializing || isClosed) {
      return;
    }

    _isInitializing = true;
    _cancelTimer();

    _session = session;
    _currentQuestionIndex = 0;
    _hasHandledExpiration = false;

    emit(const StartExamScreenLoading());

    final Either<AppErrorModel, CachedExamAttemptEntity?> cacheResult =
        await _getCachedExamAttemptUseCase(resultId: session.attempt.resultId);

    if (isClosed) {
      _isInitializing = false;

      return;
    }

    cacheResult.fold(
      (AppErrorModel error) {
        emit(StartExamScreenFailure(error: error));
      },
      (CachedExamAttemptEntity? cachedAttempt) {
        if (cachedAttempt == null) {
          emit(
            StartExamScreenFailure(
              error: LocalStorageErrorHandler.dataNotFound(),
            ),
          );

          return;
        }

        _cachedAttempt = cachedAttempt;
        _remainingDuration = _calculateRemainingDuration();

        _emitReadyState();

        if (cachedAttempt.isPendingSubmission) {
          unawaited(submitExam(isAutomatic: cachedAttempt.isTimeExpired));

          return;
        }

        if (_remainingDuration == Duration.zero) {
          unawaited(_handleTimeExpired());

          return;
        }

        _startTimer();
      },
    );

    _isInitializing = false;
  }

  Future<void> retryLoading() async {
    final StudentExamSessionEntity? session = _session;

    if (session == null || isClosed) {
      return;
    }

    await initialize(session: session);
  }

  void changeQuestion(int index) {
    final StudentExamSessionEntity? session = _session;

    if (session == null ||
        index < 0 ||
        index >= session.questions.length ||
        index == _currentQuestionIndex ||
        _isSubmitting ||
        isClosed) {
      return;
    }

    _currentQuestionIndex = index;

    _emitReadyState();
  }

  Future<void> saveAnswer({
    required String questionId,
    required int? selectedChoiceIndex,
  }) async {
    final CachedExamAttemptEntity? cachedAttempt = _cachedAttempt;

    if (cachedAttempt == null ||
        _isSubmitting ||
        _remainingDuration == Duration.zero ||
        cachedAttempt.isPendingSubmission ||
        isClosed) {
      return;
    }

    if (selectedChoiceIndex != null &&
        (selectedChoiceIndex < 0 || selectedChoiceIndex > 3)) {
      return;
    }

    final String normalizedQuestionId = questionId.trim();

    if (normalizedQuestionId.isEmpty ||
        !cachedAttempt.questionIds.contains(normalizedQuestionId)) {
      return;
    }

    final int? previousChoiceIndex = cachedAttempt.selectedChoiceFor(
      normalizedQuestionId,
    );

    if (previousChoiceIndex == selectedChoiceIndex) {
      return;
    }

    final Map<String, int> updatedAnswers = Map<String, int>.from(
      cachedAttempt.selectedChoiceIndexes,
    );

    if (selectedChoiceIndex == null) {
      updatedAnswers.remove(normalizedQuestionId);
    } else {
      updatedAnswers[normalizedQuestionId] = selectedChoiceIndex;
    }

    _cachedAttempt = cachedAttempt.copyWith(
      selectedChoiceIndexes: Map<String, int>.unmodifiable(updatedAnswers),
      updatedAt: DateTime.now().toUtc(),
    );

    _emitReadyState();

    final Either<AppErrorModel, Unit> saveResult = await _saveExamAnswerUseCase(
      resultId: cachedAttempt.resultId,
      questionId: normalizedQuestionId,
      selectedChoiceIndex: selectedChoiceIndex,
    );

    if (isClosed) {
      return;
    }

    saveResult.fold((AppErrorModel error) {
      _rollbackAnswerIfUnchanged(
        questionId: normalizedQuestionId,
        failedChoiceIndex: selectedChoiceIndex,
        previousChoiceIndex: previousChoiceIndex,
      );

      _emitActionFailure(error: error, isSubmissionFailure: false);
    }, (Unit _) {});
  }

  Future<void> submitExam({required bool isAutomatic}) async {
    final StudentExamSessionEntity? session = _session;
    final CachedExamAttemptEntity? cachedAttempt = _cachedAttempt;

    if (session == null || cachedAttempt == null || _isSubmitting || isClosed) {
      return;
    }

    _isSubmitting = true;
    _cancelTimer();

    _remainingDuration = _calculateRemainingDuration();

    emit(
      StartExamScreenSubmitting(
        session: session,
        cachedAttempt: cachedAttempt,
        currentQuestionIndex: _currentQuestionIndex,
        remainingDuration: _remainingDuration,
        isAutomatic: isAutomatic,
      ),
    );

    final SubmitStudentExamEntity submission = _createSubmission(
      session: session,
      cachedAttempt: cachedAttempt,
      isAutomatic: isAutomatic,
    );

    final Either<AppErrorModel, StudentExamResultEntity> submissionResult =
        await _submitStudentExamUseCase(submission: submission);

    _isSubmitting = false;

    if (isClosed) {
      return;
    }

    await submissionResult.fold<Future<void>>(
      (AppErrorModel error) async {
        await _refreshCachedAttempt();

        if (isClosed) {
          return;
        }

        _remainingDuration = _calculateRemainingDuration();

        _emitActionFailure(error: error, isSubmissionFailure: true);

        final CachedExamAttemptEntity? currentAttempt = _cachedAttempt;

        if (_remainingDuration > Duration.zero &&
            currentAttempt?.isPendingSubmission != true) {
          _startTimer();
        }
      },
      (StudentExamResultEntity result) async {
        emit(StartExamScreenResultReady(result: result));
      },
    );
  }

  void restoreExamState() {
    if (_isSubmitting || isClosed) {
      return;
    }

    _emitReadyState();
  }

  void _startTimer() {
    _cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), _handleTimerTick);
  }

  void _handleTimerTick(Timer timer) {
    if (isClosed || _isSubmitting) {
      return;
    }

    final Duration updatedDuration = _calculateRemainingDuration();

    if (updatedDuration == _remainingDuration) {
      return;
    }

    _remainingDuration = updatedDuration;
    _emitReadyState();

    if (_remainingDuration == Duration.zero) {
      unawaited(_handleTimeExpired());
    }
  }

  Future<void> _handleTimeExpired() async {
    if (_hasHandledExpiration || _isSubmitting || isClosed) {
      return;
    }

    _hasHandledExpiration = true;
    _remainingDuration = Duration.zero;
    _cancelTimer();

    _emitReadyState();

    await submitExam(isAutomatic: true);
  }

  Duration _calculateRemainingDuration() {
    final StudentExamSessionEntity? session = _session;

    if (session == null) {
      return Duration.zero;
    }

    final int remainingMilliseconds = session.attempt.expiresAt
        .toUtc()
        .difference(DateTime.now().toUtc())
        .inMilliseconds;

    if (remainingMilliseconds <= 0) {
      return Duration.zero;
    }

    final int remainingSeconds = (remainingMilliseconds / 1000).ceil();

    return Duration(seconds: remainingSeconds);
  }

  SubmitStudentExamEntity _createSubmission({
    required StudentExamSessionEntity session,
    required CachedExamAttemptEntity cachedAttempt,
    required bool isAutomatic,
  }) {
    final List<StudentExamAnswerEntity> answers = <StudentExamAnswerEntity>[];

    for (final StudentExamQuestionEntity question in session.questions) {
      final int? selectedChoiceIndex = cachedAttempt.selectedChoiceFor(
        question.questionId,
      );

      if (selectedChoiceIndex == null) {
        continue;
      }

      answers.add(
        StudentExamAnswerEntity(
          questionId: question.questionId,
          selectedChoiceIndex: selectedChoiceIndex,
        ),
      );
    }

    return SubmitStudentExamEntity(
      examId: session.exam.examId,
      resultId: session.attempt.resultId,
      answers: List<StudentExamAnswerEntity>.unmodifiable(answers),
      isAutomatic: isAutomatic,
    );
  }

  Future<void> _refreshCachedAttempt() async {
    final CachedExamAttemptEntity? cachedAttempt = _cachedAttempt;

    if (cachedAttempt == null || isClosed) {
      return;
    }

    final Either<AppErrorModel, CachedExamAttemptEntity?> cacheResult =
        await _getCachedExamAttemptUseCase(resultId: cachedAttempt.resultId);

    if (isClosed) {
      return;
    }

    cacheResult.fold((AppErrorModel _) {}, (
      CachedExamAttemptEntity? refreshedAttempt,
    ) {
      if (refreshedAttempt != null) {
        _cachedAttempt = refreshedAttempt;
      }
    });
  }

  void _rollbackAnswerIfUnchanged({
    required String questionId,
    required int? failedChoiceIndex,
    required int? previousChoiceIndex,
  }) {
    final CachedExamAttemptEntity? currentAttempt = _cachedAttempt;

    if (currentAttempt == null ||
        currentAttempt.selectedChoiceFor(questionId) != failedChoiceIndex) {
      return;
    }

    final Map<String, int> restoredAnswers = Map<String, int>.from(
      currentAttempt.selectedChoiceIndexes,
    );

    if (previousChoiceIndex == null) {
      restoredAnswers.remove(questionId);
    } else {
      restoredAnswers[questionId] = previousChoiceIndex;
    }

    _cachedAttempt = currentAttempt.copyWith(
      selectedChoiceIndexes: Map<String, int>.unmodifiable(restoredAnswers),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  void _emitReadyState() {
    final StudentExamSessionEntity? session = _session;
    final CachedExamAttemptEntity? cachedAttempt = _cachedAttempt;

    if (session == null || cachedAttempt == null || isClosed) {
      return;
    }

    emit(
      StartExamScreenReady(
        session: session,
        cachedAttempt: cachedAttempt,
        currentQuestionIndex: _currentQuestionIndex,
        remainingDuration: _remainingDuration,
      ),
    );
  }

  void _emitActionFailure({
    required AppErrorModel error,
    required bool isSubmissionFailure,
  }) {
    final StudentExamSessionEntity? session = _session;
    final CachedExamAttemptEntity? cachedAttempt = _cachedAttempt;

    if (session == null || cachedAttempt == null || isClosed) {
      return;
    }

    emit(
      StartExamScreenActionFailure(
        session: session,
        cachedAttempt: cachedAttempt,
        currentQuestionIndex: _currentQuestionIndex,
        remainingDuration: _remainingDuration,
        error: error,
        isSubmissionFailure: isSubmissionFailure,
      ),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() async {
    _cancelTimer();

    return super.close();
  }
}
