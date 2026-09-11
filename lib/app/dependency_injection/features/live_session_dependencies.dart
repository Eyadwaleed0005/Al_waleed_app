import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/live_session/data/data_source/firebase_live_session_remote_data_source.dart';
import 'package:al_waleed/features/live_session/data/data_source/live_session_remote_data_source.dart';
import 'package:al_waleed/features/live_session/data/repo/live_session_repo_impl.dart';
import 'package:al_waleed/features/live_session/domain/repo/live_session_repo.dart';
import 'package:al_waleed/features/live_session/domain/usecase/live_session_usecase.dart';
import 'package:al_waleed/features/live_session/presentation/cubits/live_session_cubit/live_session_cubit.dart';
import 'package:get_it/get_it.dart';

void registerLiveSessionDependencies(GetIt getIt) {
  getIt.registerLazySingleton<LiveSessionRemoteDataSource>(
    () => FirebaseLiveSessionRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<LiveSessionRepo>(
    () => LiveSessionRepoImpl(
      liveSessionRemoteDataSource: getIt<LiveSessionRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LiveSessionUseCase>(
    () => LiveSessionUseCase(
      liveSessionRepo: getIt<LiveSessionRepo>(),
    ),
  );

  getIt.registerFactory<LiveSessionCubit>(
    () => LiveSessionCubit(
      liveSessionUseCase: getIt<LiveSessionUseCase>(),
    ),
  );
}