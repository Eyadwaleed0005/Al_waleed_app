import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/network/internet_connection_network_info.dart';
import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/core/firebase/storage/firebase_storage_service.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source_impl.dart';
import 'package:al_waleed/features/profile/data/repositories/student_profile_repositoy_impl.dart';
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';
import 'package:al_waleed/features/profile/domain/usecase/get_student_profile_use_case.dart';
import 'package:al_waleed/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instanceFor(region: 'us-central1'),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );

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

  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<StudentProfileDataSource>(
    () => StudentProfileDataSourceImpl(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<StudentProfileRepository>(
    () => StudentProfileRepositoryImpl(
      dataSource: getIt<StudentProfileDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(
      studentProfileRepository: getIt<StudentProfileRepository>(),
    ),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getStudentProfileUseCase: getIt<GetProfileUseCase>()),
  );
}
