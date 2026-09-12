import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/firebase_storage_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

void registerCoreDependencies(GetIt getIt) {
  _registerFirebaseDependencies(getIt);
  _registerNetworkDependencies(getIt);
  _registerCoreServices(getIt);
  _registerCoreCubits(getIt);
}

void _registerFirebaseDependencies(GetIt getIt) {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instanceFor(region: 'us-central1'),
  );
}

void _registerNetworkDependencies(GetIt getIt) {
  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );
}

void _registerCoreServices(GetIt getIt) {
  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(
      networkInfo: getIt<NetworkInfo>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<StorageService>(
    () => FirebaseStorageService(
      networkInfo: getIt<NetworkInfo>(),
      firebaseStorage: getIt<FirebaseStorage>(),
    ),
  );
}

void _registerCoreCubits(GetIt getIt) {
  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );
}
