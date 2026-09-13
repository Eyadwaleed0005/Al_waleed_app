import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/use_cases/get_pending_exam_submissions_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/resume_student_exam_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/start_student_exam_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/stream_available_exams_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'exams_screen_state.dart';

class ExamsScreenCubit extends Cubit<ExamsScreenState> {
  ExamsScreenCubit({
    required StreamAvailableExamsUseCase streamAvailableExamsUseCase,
    required StartStudentExamUseCase startStudentExamUseCase,
    required ResumeStudentExamUseCase resumeStudentExamUseCase,
    required GetPendingExamSubmissionsUseCase getPendingExamSubmissionsUseCase,
  }) : _streamAvailableExamsUseCase = streamAvailableExamsUseCase,
       _startStudentExamUseCase = startStudentExamUseCase,
       _resumeStudentExamUseCase = resumeStudentExamUseCase,
       _getPendingExamSubmissionsUseCase = getPendingExamSubmissionsUseCase,
       super(const ExamsScreenInitial());
  final StreamAvailableExamsUseCase _streamAvailableExamsUseCase;
  final StartStudentExamUseCase _startStudentExamUseCase;
  final ResumeStudentExamUseCase _resumeStudentExamUseCase;

  final GetPendingExamSubmissionsUseCase _getPendingExamSubmissionsUseCase;

  StreamSubscription<Either<AppErrorModel, List<StudentExamListItemEntity>>>?
  _examsSubscription;

  String? _gradeId;

  List<StudentExamListItemEntity> _latestExams =
      const <StudentExamListItemEntity>[];

  Set<String> _hiddenExamIds = <String>{};

  bool _isOpeningExam = false;

  Future<void> loadExams({required String gradeId}) async {
    final String normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      return;
    }

    _gradeId = normalizedGradeId;

    await _examsSubscription?.cancel();
    _examsSubscription = null;

    if (isClosed) {
      return;
    }

    emit(const ExamsScreenLoading());

    final bool pendingAttemptsLoaded = await _loadPendingExamIds();

    if (!pendingAttemptsLoaded || isClosed) {
      return;
    }

    _examsSubscription = _streamAvailableExamsUseCase(
      gradeId: normalizedGradeId,
    ).listen(_handleExamsResult);
  }

  Future<void> retryLoading() async {
    final String? gradeId = _gradeId;

    if (gradeId == null || gradeId.isEmpty) {
      return;
    }

    await loadExams(gradeId: gradeId);
  }

  Future<void> openExam({required StudentExamListItemEntity examItem}) async {
    if (_isOpeningExam || examItem.shouldBeHidden) {
      return;
    }

    final StudentExamAttemptEntity? attempt = examItem.attempt;

    if (attempt == null && !examItem.canStart) {
      return;
    }

    _isOpeningExam = true;

    emit(
      ExamsScreenOpeningExam(exams: _latestExams, examId: examItem.exam.examId),
    );

    final Either<AppErrorModel, StudentExamSessionEntity> sessionResult;

    if (attempt == null) {
      sessionResult = await _startStudentExamUseCase(
        examId: examItem.exam.examId,
      );
    } else {
      sessionResult = await _resumeStudentExamUseCase(
        examId: examItem.exam.examId,
        resultId: attempt.resultId,
      );
    }

    _isOpeningExam = false;

    if (isClosed) {
      return;
    }

    sessionResult.fold(
      (AppErrorModel error) {
        emit(ExamsScreenActionFailure(exams: _latestExams, error: error));
      },
      (StudentExamSessionEntity session) {
        emit(ExamsScreenSessionReady(exams: _latestExams, session: session));
      },
    );
  }

  void hideExam({required String examId}) {
    if (isClosed) {
      return;
    }

    final String normalizedExamId = examId.trim();

    if (normalizedExamId.isEmpty) {
      return;
    }

    _hiddenExamIds.add(normalizedExamId);

    _latestExams = List<StudentExamListItemEntity>.unmodifiable(
      _latestExams.where((StudentExamListItemEntity examItem) {
        return examItem.exam.examId.trim() != normalizedExamId;
      }),
    );

    _emitCurrentExams();
  }

  void restoreExamsState() {
    if (_isOpeningExam || isClosed) {
      return;
    }

    _emitCurrentExams();
  }

  Future<bool> _loadPendingExamIds() async {
    final Either<AppErrorModel, List<CachedExamAttemptEntity>> result =
        await _getPendingExamSubmissionsUseCase();

    if (isClosed) {
      return false;
    }

    return result.fold(
      (AppErrorModel error) {
        emit(ExamsScreenFailure(error: error));

        return false;
      },
      (List<CachedExamAttemptEntity> attempts) {
        _hiddenExamIds = attempts
            .map((CachedExamAttemptEntity attempt) {
              return attempt.examId.trim();
            })
            .where((String examId) {
              return examId.isNotEmpty;
            })
            .toSet();

        return true;
      },
    );
  }

  void _handleExamsResult(
    Either<AppErrorModel, List<StudentExamListItemEntity>> result,
  ) {
    if (isClosed) {
      return;
    }

    result.fold(
      (AppErrorModel error) {
        if (!_isOpeningExam) {
          emit(ExamsScreenFailure(error: error));
        }
      },
      (List<StudentExamListItemEntity> exams) {
        _latestExams = List<StudentExamListItemEntity>.unmodifiable(
          exams.where((StudentExamListItemEntity examItem) {
            final String examId = examItem.exam.examId.trim();

            return !examItem.shouldBeHidden && !_hiddenExamIds.contains(examId);
          }),
        );

        if (!_isOpeningExam) {
          _emitCurrentExams();
        }
      },
    );
  }

  void _emitCurrentExams() {
    if (_latestExams.isEmpty) {
      emit(const ExamsScreenEmpty());

      return;
    }

    emit(ExamsScreenSuccess(exams: _latestExams));
  }

  @override
  Future<void> close() async {
    await _examsSubscription?.cancel();
    _examsSubscription = null;

    return super.close();
  }
}
