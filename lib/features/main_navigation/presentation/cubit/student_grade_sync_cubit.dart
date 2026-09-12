import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/main_navigation/domain/use_case/stream_student_grade_id_use_case.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/student_grade_sync_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentGradeSyncCubit extends Cubit<StudentGradeSyncState> {
  StudentGradeSyncCubit({
    required StreamStudentGradeIdUseCase streamStudentGradeIdUseCase,
  }) : _streamStudentGradeIdUseCase = streamStudentGradeIdUseCase,
       super(const StudentGradeSyncInitial());

  final StreamStudentGradeIdUseCase _streamStudentGradeIdUseCase;

  StreamSubscription<Either<AppErrorModel, String>>? _gradeSubscription;

  bool _isInitializing = false;
  bool _isClosing = false;

  bool get _canEmit {
    return !_isClosing && !isClosed;
  }

  Future<void> initialize() async {
    if (_isInitializing || !_canEmit) {
      return;
    }

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (!_canEmit) {
        return;
      }

      emit(const StudentGradeSyncLoading());

      _gradeSubscription = _streamStudentGradeIdUseCase().listen(
        _onGradeResult,
      );
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void _onGradeResult(
    Either<AppErrorModel, String> result,
  ) {
    if (!_canEmit) {
      return;
    }

    result.fold(
      _emitFailure,
      _emitSuccess,
    );
  }

  void _emitSuccess(String gradeId) {
    if (!_canEmit) {
      return;
    }

    final normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      return;
    }

    final currentState = state;

    if (currentState is StudentGradeSyncSuccess &&
        currentState.gradeId == normalizedGradeId) {
      return;
    }

    emit(
      StudentGradeSyncSuccess(
        gradeId: normalizedGradeId,
      ),
    );
  }

  void _emitFailure(AppErrorModel error) {
    if (!_canEmit) {
      return;
    }

    emit(
      StudentGradeSyncFailure(
        error: error,
      ),
    );
  }

  Future<void> _cancelSubscription() async {
    await _gradeSubscription?.cancel();
    _gradeSubscription = null;
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) {
      return;
    }

    _isClosing = true;

    await _cancelSubscription();

    return super.close();
  }
}