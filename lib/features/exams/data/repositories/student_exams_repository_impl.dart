import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/student_exams_remote_data_source.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_status.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/repositories/student_exams_repository.dart';
import 'package:dartz/dartz.dart';

class StudentExamsRepositoryImpl implements StudentExamsRepository {
  const StudentExamsRepositoryImpl({required this._remoteDataSource});

  final StudentExamsRemoteDataSource _remoteDataSource;

  @override
  Stream<Either<AppErrorModel, List<StudentExamListItemEntity>>>
  streamAvailableExams({required String gradeId}) {
    return _combineExamsAndAttempts(gradeId: gradeId);
  }

  Stream<Either<AppErrorModel, List<StudentExamListItemEntity>>>
  _combineExamsAndAttempts({required String gradeId}) {
    late final StreamController<
      Either<AppErrorModel, List<StudentExamListItemEntity>>
    >
    controller;

    StreamSubscription<List<StudentExamEntity>>? examsSubscription;

    StreamSubscription<List<StudentExamAttemptEntity>>? attemptsSubscription;

    List<StudentExamEntity>? latestExams;
    List<StudentExamAttemptEntity>? latestAttempts;

    bool examsStreamCompleted = false;
    bool attemptsStreamCompleted = false;

    void emitCurrentData() {
      if (controller.isClosed) {
        return;
      }

      final List<StudentExamEntity>? exams = latestExams;
      final List<StudentExamAttemptEntity>? attempts = latestAttempts;

      if (exams == null || attempts == null) {
        return;
      }

      final List<StudentExamListItemEntity> availableExams =
          _buildAvailableExamItems(exams: exams, attempts: attempts);

      controller.add(
        Right(List<StudentExamListItemEntity>.unmodifiable(availableExams)),
      );
    }

    void emitError(Object error, [StackTrace? _]) {
      if (controller.isClosed) {
        return;
      }

      controller.add(Left(FirebaseErrorHandler.handle(error)));
    }

    Future<void> closeControllerIfFinished() async {
      if (!examsStreamCompleted || !attemptsStreamCompleted) {
        return;
      }

      if (controller.isClosed) {
        return;
      }

      await controller.close();
    }

    Future<void> cancelSubscriptions() async {
      final StreamSubscription<List<StudentExamEntity>>?
      currentExamsSubscription = examsSubscription;

      final StreamSubscription<List<StudentExamAttemptEntity>>?
      currentAttemptsSubscription = attemptsSubscription;

      examsSubscription = null;
      attemptsSubscription = null;

      await Future.wait<void>([
        if (currentExamsSubscription != null) currentExamsSubscription.cancel(),
        if (currentAttemptsSubscription != null)
          currentAttemptsSubscription.cancel(),
      ]);
    }

    void startListening() {
      try {
        examsSubscription = _remoteDataSource
            .streamGradeExams(gradeId: gradeId)
            .listen(
              (List<StudentExamEntity> exams) {
                latestExams = exams;
                emitCurrentData();
              },
              onError: emitError,
              onDone: () {
                examsStreamCompleted = true;
                unawaited(closeControllerIfFinished());
              },
            );

        attemptsSubscription = _remoteDataSource.streamStudentAttempts().listen(
          (List<StudentExamAttemptEntity> attempts) {
            latestAttempts = attempts;
            emitCurrentData();
          },
          onError: emitError,
          onDone: () {
            attemptsStreamCompleted = true;
            unawaited(closeControllerIfFinished());
          },
        );
      } catch (error, stackTrace) {
        emitError(error, stackTrace);
      }
    }

    controller =
        StreamController<
          Either<AppErrorModel, List<StudentExamListItemEntity>>
        >(
          onListen: startListening,
          onPause: () {
            examsSubscription?.pause();
            attemptsSubscription?.pause();
          },
          onResume: () {
            examsSubscription?.resume();
            attemptsSubscription?.resume();
          },
          onCancel: cancelSubscriptions,
        );

    return controller.stream;
  }

  @override
  Future<Either<AppErrorModel, StudentExamSessionEntity>> startExam({
    required String examId,
  }) async {
    try {
      final StudentExamSessionEntity session = await _remoteDataSource
          .startExam(examId: examId);

      return Right(session);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, StudentExamSessionEntity>> resumeExam({
    required String examId,
    required String resultId,
  }) async {
    try {
      final StudentExamSessionEntity session = await _remoteDataSource
          .resumeExam(examId: examId, resultId: resultId);

      return Right(session);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, StudentExamResultEntity>> submitExam({
    required SubmitStudentExamEntity submission,
  }) async {
    try {
      final StudentExamResultEntity result = await _remoteDataSource.submitExam(
        submission: submission,
      );

      return Right(result);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }

  List<StudentExamListItemEntity> _buildAvailableExamItems({
    required List<StudentExamEntity> exams,
    required List<StudentExamAttemptEntity> attempts,
  }) {
    final Map<String, StudentExamAttemptEntity> attemptsByExamId =
        <String, StudentExamAttemptEntity>{};

    for (final StudentExamAttemptEntity attempt in attempts) {
      attemptsByExamId[attempt.examId.trim()] = attempt;
    }

    final List<StudentExamListItemEntity> availableExams =
        <StudentExamListItemEntity>[];

    for (final StudentExamEntity exam in exams) {
      if (exam.status != StudentExamStatus.published) {
        continue;
      }

      final StudentExamAttemptEntity? attempt =
          attemptsByExamId[exam.examId.trim()];

      if (attempt?.isSubmitted == true) {
        continue;
      }

      availableExams.add(
        StudentExamListItemEntity(exam: exam, attempt: attempt),
      );
    }

    return List<StudentExamListItemEntity>.unmodifiable(availableExams);
  }
}
