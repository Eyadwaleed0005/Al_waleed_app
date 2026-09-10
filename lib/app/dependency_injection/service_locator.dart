import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/firebase_storage_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';
import 'package:al_waleed/features/secure_screen/data/data_sources/screen_protector_secure_screen_data_source.dart';
import 'package:al_waleed/features/secure_screen/data/data_sources/secure_screen_data_source.dart';
import 'package:al_waleed/features/secure_screen/data/repositories/secure_screen_repository_impl.dart';
import 'package:al_waleed/features/secure_screen/domain/repositories/secure_screen_repository.dart';
import 'package:al_waleed/features/secure_screen/domain/use_case/disable_secure_screen_use_case.dart';
import 'package:al_waleed/features/secure_screen/domain/use_case/enable_secure_screen_use_case.dart';
import 'package:al_waleed/features/secure_screen/presentation/service/secure_screen_service.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/firebase_study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/repositories/study_notes_repository_impl.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );
  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );
  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<StorageService>(
    () => FirebaseStorageService(
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<StudyNotesRemoteDataSource>(
    () => FirebaseStudyNotesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<StudyNotesRepository>(
    () => StudyNotesRepositoryImpl(
      remoteDataSource: getIt<StudyNotesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetStudyNoteByIdUseCase>(
    () => GetStudyNoteByIdUseCase(
      repository: getIt<StudyNotesRepository>(),
    ),
  );

  getIt.registerLazySingleton<StreamStudyNotesUseCase>(
    () => StreamStudyNotesUseCase(
      repository: getIt<StudyNotesRepository>(),
    ),
  );

  getIt.registerFactory<StudyNotesCubit>(
    () => StudyNotesCubit(
      streamStudyNotesUseCase: getIt<StreamStudyNotesUseCase>(),
    ),
  );

  getIt.registerLazySingleton<SecureScreenDataSource>(
    () => const ScreenProtectorSecureScreenDataSource(),
  );

  getIt.registerLazySingleton<SecureScreenRepository>(
    () => SecureScreenRepositoryImpl(
      dataSource: getIt<SecureScreenDataSource>(),
    ),
  );

  getIt.registerLazySingleton<EnableSecureScreenUseCase>(
    () => EnableSecureScreenUseCase(
      repository: getIt<SecureScreenRepository>(),
    ),
  );

  getIt.registerLazySingleton<DisableSecureScreenUseCase>(
    () => DisableSecureScreenUseCase(
      repository: getIt<SecureScreenRepository>(),
    ),
  );

  getIt.registerLazySingleton<SecureScreenService>(
    () => SecureScreenService(
      enableSecureScreenUseCase:
          getIt<EnableSecureScreenUseCase>(),
      disableSecureScreenUseCase:
          getIt<DisableSecureScreenUseCase>(),
    ),
  );
}
