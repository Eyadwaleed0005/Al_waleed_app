import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/cache/secure_login_local_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/firebase_login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/data_source/remote/login_remote_data_source.dart';
import 'package:al_waleed/features/authentication/data/repositories/login_repo_impl.dart';
import 'package:al_waleed/features/authentication/domain/repositories/login_repo.dart';
import 'package:al_waleed/features/authentication/domain/usecase/login_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

void registerAuthenticationDependencies(GetIt getIt) {
  getIt.registerLazySingleton<LoginLocalDataSource>(
    () => SecureLoginLocalDataSource(),
  );

  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => FirebaseLoginRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
      loginLocalDataSource: getIt<LoginLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(
      loginRemoteDataSource: getIt<LoginRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      repo: getIt<LoginRepo>(),
    ),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}