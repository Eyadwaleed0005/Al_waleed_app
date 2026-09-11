import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/firebase_storage_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

void registerCoreDependencies(GetIt getIt) {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );

  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(networkInfo: getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<StorageService>(
    () => FirebaseStorageService(networkInfo: getIt<NetworkInfo>()),
  );
}
