import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/firebase_study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:al_waleed/features/study_notes/data/repositories/study_notes_repository_impl.dart';
import 'package:al_waleed/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // ===== Core =====

  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );
  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );

  // ===== Study Notes Feature =====

  // Data Layer

  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(networkInfo: getIt<NetworkInfo>()),
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

  // Domain Layer

  getIt.registerLazySingleton<GetStudyNotesUseCase>(
    () => GetStudyNotesUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<GetStudyNoteByIdUseCase>(
    () => GetStudyNoteByIdUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<StreamStudyNotesUseCase>(
    () => StreamStudyNotesUseCase(repository: getIt<StudyNotesRepository>()),
  );
}
