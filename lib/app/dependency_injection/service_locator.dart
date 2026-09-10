import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/firebase_storage_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';

// Authentication
import 'package:al_waleed/features/authentication/data/data_source/cache/login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/secure_login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/firebase_login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/repositories/login_repo_impl.dart';
import 'package:al_waleed/features/authentication/domain/repositories/login_repo.dart';
import 'package:al_waleed/features/authentication/domain/usecase/login_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/login_cubit/login_cubit.dart';

// Study Notes
import 'package:al_waleed/features/study_notes/data/data_sources/firebase_study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/repositories/study_notes_repository_impl.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  _registerCoreDependencies();
  _registerAuthenticationDependencies();
  _registerStudyNotesDependencies();
}

void _registerCoreDependencies() {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Network
  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );

  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );

  // Core services
  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(networkInfo: getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<StorageService>(
    () => FirebaseStorageService(networkInfo: getIt<NetworkInfo>()),
  );
}

void _registerAuthenticationDependencies() {
  // Local data source
  getIt.registerLazySingleton<LoginLocalDataSource>(
    () => SecureLoginLocalDataSource(),
  );

  // Remote data source
  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => FirebaseLoginRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
      loginLocalDataSource: getIt<LoginLocalDataSource>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(loginRemoteDataSource: getIt<LoginRemoteDataSource>()),
  );

  // Use case
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repo: getIt<LoginRepo>()),
  );

  // Cubit
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(loginUseCase: getIt<LoginUseCase>()),
  );
}

void _registerStudyNotesDependencies() {
  // Remote data source
  getIt.registerLazySingleton<StudyNotesRemoteDataSource>(
    () => FirebaseStudyNotesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<StudyNotesRepository>(
    () => StudyNotesRepositoryImpl(
      remoteDataSource: getIt<StudyNotesRemoteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetStudyNoteByIdUseCase>(
    () => GetStudyNoteByIdUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<StreamStudyNotesUseCase>(
    () => StreamStudyNotesUseCase(repository: getIt<StudyNotesRepository>()),
  );

  // Cubit
  getIt.registerFactory<StudyNotesCubit>(
    () => StudyNotesCubit(
      streamStudyNotesUseCase: getIt<StreamStudyNotesUseCase>(),
    ),
  );
}
