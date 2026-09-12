import 'package:al_waleed/features/app_startup/data/data_source/cache/app_startup_local_data_source.dart';
import 'package:al_waleed/features/app_startup/data/data_source/cache/device_app_startup_local_data_source.dart';
import 'package:al_waleed/features/app_startup/data/data_source/remote/app_startup_remote_data_source.dart';
import 'package:al_waleed/features/app_startup/data/data_source/remote/firebase_app_startup_remote_data_source.dart';
import 'package:al_waleed/features/app_startup/data/repositories/app_startup_repository_impl.dart';
import 'package:al_waleed/features/app_startup/domain/repositories/app_startup_repository.dart';
import 'package:al_waleed/features/app_startup/domain/use_cases/resolve_app_startup_destination_use_case.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

void registerAppStartupDependencies(GetIt getIt) {
  _registerDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerDataSources(GetIt getIt) {
  getIt.registerLazySingleton<AppStartupLocalDataSource>(
    () => DeviceAppStartupLocalDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<AppStartupRemoteDataSource>(
    () => FirebaseAppStartupRemoteDataSource(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<AppStartupRepository>(
    () => AppStartupRepositoryImpl(
      localDataSource: getIt<AppStartupLocalDataSource>(),
      remoteDataSource: getIt<AppStartupRemoteDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<ResolveAppStartupDestinationUseCase>(
    () => ResolveAppStartupDestinationUseCase(
      repository: getIt<AppStartupRepository>(),
    ),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<AppStartupCubit>(
    () => AppStartupCubit(
      resolveAppStartupDestinationUseCase:
          getIt<ResolveAppStartupDestinationUseCase>(),
    ),
  );
}