import 'package:al_waleed/features/exams/data/data_source/cache/exam_attempt_cache_data_source.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/shared_preferences_exam_attempt_cache_data_source.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/firebase_student_exams_remote_data_source.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/student_exams_remote_data_source.dart';
import 'package:al_waleed/features/exams/data/repositories/exam_attempt_cache_repository_impl.dart';
import 'package:al_waleed/features/exams/data/repositories/student_exams_repository_impl.dart';
import 'package:al_waleed/features/exams/domain/repositories/exam_attempt_cache_repository.dart';
import 'package:al_waleed/features/exams/domain/repositories/student_exams_repository.dart';
import 'package:al_waleed/features/exams/domain/use_cases/clear_cached_exam_attempt_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/get_cached_exam_attempt_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/get_pending_exam_submissions_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/mark_exam_pending_submission_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/mark_expired_exam_attempts_pending_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/resume_student_exam_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/retry_pending_exam_submissions_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/save_cached_exam_attempt_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/save_exam_answer_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/start_student_exam_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/stream_available_exams_use_case.dart';
import 'package:al_waleed/features/exams/domain/use_cases/submit_student_exam_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';

void registerExamsDependencies(GetIt getIt) {
  _registerDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
}

void _registerDataSources(GetIt getIt) {
  getIt.registerLazySingleton<StudentExamsRemoteDataSource>(() {
    return FirebaseStudentExamsRemoteDataSource(
      firestore: getIt<FirebaseFirestore>(),
      functions: getIt<FirebaseFunctions>(),
    );
  });

  getIt.registerLazySingleton<ExamAttemptCacheDataSource>(
    SharedPreferencesExamAttemptCacheDataSource.new,
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<StudentExamsRepository>(() {
    return StudentExamsRepositoryImpl(
      remoteDataSource: getIt<StudentExamsRemoteDataSource>(),
    );
  });

  getIt.registerLazySingleton<ExamAttemptCacheRepository>(() {
    return ExamAttemptCacheRepositoryImpl(
      cacheDataSource: getIt<ExamAttemptCacheDataSource>(),
    );
  });
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<StreamAvailableExamsUseCase>(() {
    return StreamAvailableExamsUseCase(
      repository: getIt<StudentExamsRepository>(),
    );
  });

  getIt.registerLazySingleton<StartStudentExamUseCase>(() {
    return StartStudentExamUseCase(
      studentExamsRepository: getIt<StudentExamsRepository>(),
      cacheRepository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<ResumeStudentExamUseCase>(() {
    return ResumeStudentExamUseCase(
      studentExamsRepository: getIt<StudentExamsRepository>(),
      cacheRepository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<GetCachedExamAttemptUseCase>(() {
    return GetCachedExamAttemptUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<SaveCachedExamAttemptUseCase>(() {
    return SaveCachedExamAttemptUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<SaveExamAnswerUseCase>(() {
    return SaveExamAnswerUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<MarkExamPendingSubmissionUseCase>(() {
    return MarkExamPendingSubmissionUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<MarkExpiredExamAttemptsPendingUseCase>(() {
    return MarkExpiredExamAttemptsPendingUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<ClearCachedExamAttemptUseCase>(() {
    return ClearCachedExamAttemptUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<GetPendingExamSubmissionsUseCase>(() {
    return GetPendingExamSubmissionsUseCase(
      repository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<SubmitStudentExamUseCase>(() {
    return SubmitStudentExamUseCase(
      studentExamsRepository: getIt<StudentExamsRepository>(),
      cacheRepository: getIt<ExamAttemptCacheRepository>(),
    );
  });

  getIt.registerLazySingleton<RetryPendingExamSubmissionsUseCase>(() {
    return RetryPendingExamSubmissionsUseCase(
      cacheRepository: getIt<ExamAttemptCacheRepository>(),
      markExpiredExamAttemptsPendingUseCase:
          getIt<MarkExpiredExamAttemptsPendingUseCase>(),
      submitStudentExamUseCase: getIt<SubmitStudentExamUseCase>(),
    );
  });
}