import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/secure_login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/firebase_login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/repositories/login_repo_impl.dart';
import 'package:al_waleed/features/authentication/domain/repositories/login_repo.dart';
import 'package:al_waleed/features/authentication/domain/usecase/login_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/device_logout_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/logout_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/firebase_logout_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/logout_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/repositories/logout_repository_impl.dart';
import 'package:al_waleed/features/authentication/domain/repositories/logout_repository.dart';
import 'package:al_waleed/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_cubit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

void registerAuthenticationDependencies(GetIt getIt) {
  _registerLocalDataSources(getIt);
  _registerRemoteDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerLocalDataSources(GetIt getIt) {
  getIt.registerLazySingleton<LoginLocalDataSource>(
    () => SecureLoginLocalDataSource(),
  );

  getIt.registerLazySingleton<LogoutLocalDataSource>(
    () => const DeviceLogoutLocalDataSource(),
  );
}

void _registerRemoteDataSources(GetIt getIt) {
  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => FirebaseLoginRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
      loginLocalDataSource: getIt<LoginLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LogoutRemoteDataSource>(
    () => FirebaseLogoutRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(
      loginRemoteDataSource: getIt<LoginRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LogoutRepository>(
    () => LogoutRepositoryImpl(
      remoteDataSource: getIt<LogoutRemoteDataSource>(),
      localDataSource: getIt<LogoutLocalDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      repo: getIt<LoginRepo>(),
    ),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      repository: getIt<LogoutRepository>(),
    ),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );

  getIt.registerFactory<LogoutCubit>(
    () => LogoutCubit(
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
}