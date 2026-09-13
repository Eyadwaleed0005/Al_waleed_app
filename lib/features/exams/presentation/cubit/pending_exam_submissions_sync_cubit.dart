import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/use_cases/retry_pending_exam_submissions_use_case.dart';
import 'package:al_waleed/features/exams/presentation/cubit/pending_exam_submissions_sync_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingExamSubmissionsSyncCubit
    extends Cubit<PendingExamSubmissionsSyncState> {
  PendingExamSubmissionsSyncCubit({
    required RetryPendingExamSubmissionsUseCase
    retryPendingExamSubmissionsUseCase,
  }) : _retryPendingExamSubmissionsUseCase = retryPendingExamSubmissionsUseCase,
       super(const PendingExamSubmissionsSyncInitial());

  final RetryPendingExamSubmissionsUseCase _retryPendingExamSubmissionsUseCase;

  static const Duration _idleCheckDuration = Duration(seconds: 30);

  static const List<Duration> _failureRetryDurations = <Duration>[
    Duration(seconds: 5),
    Duration(seconds: 15),
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 5),
  ];

  Timer? _retryTimer;

  bool _isSyncing = false;
  bool _isClosing = false;
  bool _isAutomaticSyncPaused = false;

  int _consecutiveFailures = 0;

  bool get _canWork {
    return !_isClosing && !isClosed;
  }

  Future<void> initialize() {
    return retryNow();
  }

  void pauseAutomaticSync() {
    if (!_canWork || _isAutomaticSyncPaused) {
      return;
    }

    _isAutomaticSyncPaused = true;

    _retryTimer?.cancel();
    _retryTimer = null;
  }

  void resumeAutomaticSync() {
    if (!_canWork || !_isAutomaticSyncPaused) {
      return;
    }

    _isAutomaticSyncPaused = false;

    unawaited(retryNow());
  }

  Future<void> retryNow() async {
    if (!_canWork || _isAutomaticSyncPaused || _isSyncing) {
      return;
    }

    _retryTimer?.cancel();
    _retryTimer = null;

    _isSyncing = true;

    try {
      emit(const PendingExamSubmissionsSyncInProgress());

      final Either<AppErrorModel, Unit> result =
          await _retryPendingExamSubmissionsUseCase();

      if (!_canWork) {
        return;
      }

      result.fold(_handleFailure, _handleSuccess);
    } finally {
      _isSyncing = false;
    }
  }

  void _handleSuccess(Unit _) {
    if (!_canWork) {
      return;
    }

    _consecutiveFailures = 0;

    emit(const PendingExamSubmissionsSyncSuccess());

    _scheduleRetry(_idleCheckDuration);
  }

  void _handleFailure(AppErrorModel error) {
    if (!_canWork) {
      return;
    }

    emit(PendingExamSubmissionsSyncFailure(error: error));

    final int retryIndex = _consecutiveFailures.clamp(
      0,
      _failureRetryDurations.length - 1,
    );

    final Duration retryDuration = _failureRetryDurations[retryIndex];

    _consecutiveFailures++;

    _scheduleRetry(retryDuration);
  }

  void _scheduleRetry(Duration duration) {
    if (!_canWork || _isAutomaticSyncPaused) {
      return;
    }

    _retryTimer?.cancel();

    _retryTimer = Timer(duration, () {
      unawaited(retryNow());
    });
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) {
      return;
    }

    _isClosing = true;

    _retryTimer?.cancel();
    _retryTimer = null;

    return super.close();
  }
}
