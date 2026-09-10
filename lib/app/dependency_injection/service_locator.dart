import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/login_remote_data_source/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/login_remote_data_source/login_remote_data_source_impl.dart';
import 'package:al_waleed/features/authentication/data/repo_impl/login_repo_impl.dart';
import 'package:al_waleed/features/authentication/domain/repos/login_repo.dart';
import 'package:al_waleed/features/authentication/domain/usecase/login_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/auth_cubit/login_cubit/login_cubit.dart';
import 'package:al_waleed/features/live_session/data/data_source/live_session_remote_data_source.dart';
import 'package:al_waleed/features/live_session/data/data_source/live_session_remote_data_source_impl.dart';
import 'package:al_waleed/features/live_session/data/repo_impl/live_session_repo_impl.dart';
import 'package:al_waleed/features/live_session/domain/repo/live_session_repo.dart';
import 'package:al_waleed/features/live_session/domain/usecase/live_session_usecase.dart';
import 'package:al_waleed/features/live_session/presentation/cubits/live_session_cubit/live_session_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );
  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(networkInfo: getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(loginRemoteDataSource: getIt<LoginRemoteDataSource>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repo: getIt.get<LoginRepo>()),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(loginUseCase: getIt.get<LoginUseCase>()),
  );

  getIt.registerLazySingleton<LiveSessionRemoteDataSource>(
    () => LiveSessionRemoteDataSourceImpl(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<LiveSessionRepo>(
    () => LiveSessionRepoImpl(
      liveSessionRemoteDataSource: getIt<LiveSessionRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LiveSessionUseCase>(
    () => LiveSessionUseCase(liveSessionRepo: getIt.get<LiveSessionRepo>()),
  );
  getIt.registerFactory<LiveSessionCubit>(
    () => LiveSessionCubit(liveSessionUseCase: getIt.get<LiveSessionUseCase>()),
  );
}
