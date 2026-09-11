import 'package:al_waleed/features/security_screens/data/data_sources/no_screenshot_secure_screen_data_source.dart';
import 'package:al_waleed/features/security_screens/data/data_sources/secure_screen_data_source.dart';
import 'package:al_waleed/features/security_screens/data/repositories/secure_screen_repository_impl.dart';
import 'package:al_waleed/features/security_screens/domain/repositories/secure_screen_repository.dart';
import 'package:al_waleed/features/security_screens/domain/use_case/disable_secure_screen_use_case.dart';
import 'package:al_waleed/features/security_screens/domain/use_case/enable_secure_screen_use_case.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_cubit.dart';
import 'package:get_it/get_it.dart';

void registerSecureScreenDependencies(GetIt getIt) {
  _registerDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerDataSources(GetIt getIt) {
  getIt.registerLazySingleton<SecureScreenDataSource>(
    () => NoScreenshotSecureScreenDataSource(),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<SecureScreenRepository>(
    () => SecureScreenRepositoryImpl(
      dataSource: getIt<SecureScreenDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
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
}

void _registerCubits(GetIt getIt) {
  getIt.registerLazySingleton<SecureScreenCubit>(
    () => SecureScreenCubit(
      enableSecureScreenUseCase: getIt<EnableSecureScreenUseCase>(),
      disableSecureScreenUseCase: getIt<DisableSecureScreenUseCase>(),
    ),
    dispose: (cubit) => cubit.close(),
  );
}