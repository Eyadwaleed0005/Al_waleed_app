import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';

// Local data sources
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/lesson_pdf_cache_local_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/lessons_local_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/secure_lesson_pdf_cache_local_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/local_data_source/secure_lessons_local_data_source.dart';

// Remote data sources
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/firebase_lesson_pdf_remote_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/firebase_lessons_remote_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/lesson_pdf_remote_data_source.dart';
import 'package:al_waleed/features/lessons/data/data_sources/remote_data_source/lessons_remote_data_source.dart';

// Repository implementations
import 'package:al_waleed/features/lessons/data/repositories/lesson_pdf_repository_impl.dart';
import 'package:al_waleed/features/lessons/data/repositories/lessons_repository_impl.dart';

// Repository contracts
import 'package:al_waleed/features/lessons/domain/repositories/lesson_pdf_repository.dart';
import 'package:al_waleed/features/lessons/domain/repositories/lessons_repository.dart';

// Use cases
import 'package:al_waleed/features/lessons/domain/use_case/get_lesson_by_id_use_case.dart';
import 'package:al_waleed/features/lessons/domain/use_case/get_lesson_pdf_use_case.dart';
import 'package:al_waleed/features/lessons/domain/use_case/stream_lessons_use_case.dart';

// Cubits
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_cubit.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lessons_cubit.dart';

import 'package:get_it/get_it.dart';

void registerLessonsDependencies(GetIt getIt) {
  _registerLocalDataSources(getIt);
  _registerRemoteDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerLocalDataSources(GetIt getIt) {
  getIt.registerLazySingleton<LessonsLocalDataSource>(
    () => const SecureLessonsLocalDataSource(),
  );

  getIt.registerLazySingleton<LessonPdfCacheLocalDataSource>(
    () => const SecureLessonPdfCacheLocalDataSource(),
  );
}

void _registerRemoteDataSources(GetIt getIt) {
  getIt.registerLazySingleton<LessonsRemoteDataSource>(
    () => FirebaseLessonsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<LessonPdfRemoteDataSource>(
    () => FirebaseLessonPdfRemoteDataSource(
      storageService: getIt<StorageService>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(
      localDataSource: getIt<LessonsLocalDataSource>(),
      remoteDataSource: getIt<LessonsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LessonPdfRepository>(
    () => LessonPdfRepositoryImpl(
      cacheLocalDataSource: getIt<LessonPdfCacheLocalDataSource>(),
      remoteDataSource: getIt<LessonPdfRemoteDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<GetLessonByIdUseCase>(
    () => GetLessonByIdUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<StreamLessonsUseCase>(
    () => StreamLessonsUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<GetLessonPdfUseCase>(
    () => GetLessonPdfUseCase(repository: getIt<LessonPdfRepository>()),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<LessonsCubit>(
    () => LessonsCubit(
      streamLessonsUseCase: getIt<StreamLessonsUseCase>(),
    ),
  );

  getIt.registerFactory<LessonPdfCubit>(
    () => LessonPdfCubit(
      getLessonPdfUseCase: getIt<GetLessonPdfUseCase>(),
    ),
  );
}