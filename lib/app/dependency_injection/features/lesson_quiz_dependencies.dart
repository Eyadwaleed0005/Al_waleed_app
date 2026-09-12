import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source_impl.dart' hide LessonQuizRemoteDataSource;
import 'package:al_waleed/features/lesson_quiz/data/repo_impl/lesson_quiz_repo_impl.dart';
import 'package:al_waleed/features/lesson_quiz/domain/repos/lesson_quiz_repo.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/lesson_quiz_usecase.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:get_it/get_it.dart';

void registerLessonQuizDependencies(GetIt getIt) {
  getIt.registerLazySingleton<LessonQuizRemoteDataSource>(
    () => LessonQuizRemoteDataSourceImpl(
     firestoreService: getIt<FirestoreService>()
    ),
  );

  getIt.registerLazySingleton<LessonQuizRepository>(
    () => LessonQuizRepoImpl(
     quizRemoteDataSource:  getIt<LessonQuizRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LessonQuizUseCase>(
    () => LessonQuizUseCase(
     lessonQuizRepo:getIt<LessonQuizRepository>() ,
    ),
  );

  getIt.registerFactory<LessonQuizCubit>(
    () => LessonQuizCubit(
     getLessonQuizUseCase: getIt<LessonQuizUseCase>(),
    ),
  );
}