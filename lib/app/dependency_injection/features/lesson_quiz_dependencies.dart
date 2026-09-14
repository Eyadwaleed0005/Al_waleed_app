import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/firebase_lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/repositories/lesson_quiz_repo_impl.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repositories/lesson_quiz_repo.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/calculate_lesson_quiz_result_use_case.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/lesson_quiz_usecase.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:get_it/get_it.dart';

void registerLessonQuizDependencies(GetIt getIt) {
  getIt.registerLazySingleton<LessonQuizRemoteDataSource>(
    () => FirebaseLessonQuizRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<LessonQuizRepository>(
    () => LessonQuizRepositoryImpl(
      remoteDataSource: getIt<LessonQuizRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetLessonQuizUseCase>(
    () => GetLessonQuizUseCase(
      repository: getIt<LessonQuizRepository>(),
    ),
  );

  getIt.registerLazySingleton<CalculateLessonQuizResultUseCase>(
    CalculateLessonQuizResultUseCase.new,
  );

  getIt.registerFactory<LessonQuizCubit>(
    () => LessonQuizCubit(
      getLessonQuizUseCase: getIt<GetLessonQuizUseCase>(),
    ),
  );
}