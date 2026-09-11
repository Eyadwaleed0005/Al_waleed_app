import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';

// Local data sources
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/secure_study_note_pdf_cache_local_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/secure_study_notes_local_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/study_note_pdf_cache_local_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/local_data_source/study_notes_local_data_source.dart';

// Remote data sources
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/firebase_study_note_pdf_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/firebase_study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/study_note_pdf_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/remote_data_source/study_notes_remote_data_source.dart';

// Repository implementations
import 'package:al_waleed/features/study_notes/data/repositories/study_note_pdf_repository_impl.dart';
import 'package:al_waleed/features/study_notes/data/repositories/study_notes_repository_impl.dart';

// Repository contracts
import 'package:al_waleed/features/study_notes/domain/repositories/study_note_pdf_repository.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';

// Use cases
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_note_pdf_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';

// Cubits
import 'package:al_waleed/features/study_notes/presentation/cubit/study_note_pdf_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';

import 'package:get_it/get_it.dart';

void registerStudyNotesDependencies(GetIt getIt) {
  _registerLocalDataSources(getIt);
  _registerRemoteDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerLocalDataSources(GetIt getIt) {
  getIt.registerLazySingleton<StudyNotesLocalDataSource>(
    () => const SecureStudyNotesLocalDataSource(),
  );

  getIt.registerLazySingleton<StudyNotePdfCacheLocalDataSource>(
    () => const SecureStudyNotePdfCacheLocalDataSource(),
  );
}

void _registerRemoteDataSources(GetIt getIt) {
  getIt.registerLazySingleton<StudyNotesRemoteDataSource>(
    () => FirebaseStudyNotesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<StudyNotePdfRemoteDataSource>(
    () => FirebaseStudyNotePdfRemoteDataSource(
      storageService: getIt<StorageService>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<StudyNotesRepository>(
    () => StudyNotesRepositoryImpl(
      localDataSource: getIt<StudyNotesLocalDataSource>(),
      remoteDataSource: getIt<StudyNotesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<StudyNotePdfRepository>(
    () => StudyNotePdfRepositoryImpl(
      cacheLocalDataSource: getIt<StudyNotePdfCacheLocalDataSource>(),
      remoteDataSource: getIt<StudyNotePdfRemoteDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<GetStudyNoteByIdUseCase>(
    () => GetStudyNoteByIdUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<StreamStudyNotesUseCase>(
    () => StreamStudyNotesUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<GetStudyNotePdfUseCase>(
    () => GetStudyNotePdfUseCase(repository: getIt<StudyNotePdfRepository>()),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<StudyNotesCubit>(
    () => StudyNotesCubit(
      streamStudyNotesUseCase: getIt<StreamStudyNotesUseCase>(),
    ),
  );

  getIt.registerFactory<StudyNotePdfCubit>(
    () => StudyNotePdfCubit(
      getStudyNotePdfUseCase: getIt<GetStudyNotePdfUseCase>(),
    ),
  );
}
