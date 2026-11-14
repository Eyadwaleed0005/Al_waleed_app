import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/profile/data/data_source/firebase_my_subscription_remote_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/firebase_personal_info_remote_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/firebase_student_profile_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/my_subscription_remote_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/personal_info_remote_data_source.dart';
import 'package:al_waleed/features/profile/data/data_source/student_profile_data_source.dart';
import 'package:al_waleed/features/profile/data/repositories/my_subscription_repository_impl.dart';
import 'package:al_waleed/features/profile/data/repositories/personal_info_repository_impl.dart';
import 'package:al_waleed/features/profile/data/repositories/student_profile_repositoy_impl.dart';
import 'package:al_waleed/features/profile/domain/repositories/my_subscription_repository.dart';
import 'package:al_waleed/features/profile/domain/repositories/personal_info_repository.dart';
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';
import 'package:al_waleed/features/profile/domain/usecase/get_personal_info_use_case.dart';
import 'package:al_waleed/features/profile/domain/usecase/stream_my_subscription_use_case.dart';
import 'package:al_waleed/features/profile/domain/usecase/stream_student_profile_use_case.dart';
import 'package:al_waleed/features/profile/domain/usecase/update_personal_info_use_case.dart';
import 'package:al_waleed/features/profile/presentation/cubit/my_subscription_cubit/my_subscription_cubit.dart';
import 'package:al_waleed/features/profile/presentation/cubit/personal_info_cubit/personal_info_cubit.dart';
import 'package:al_waleed/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

void registerProfileDependencies(GetIt getIt) {
  _registerDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerDataSources(GetIt getIt) {
  getIt.registerLazySingleton<StudentProfileDataSource>(
    () => FirebaseStudentProfileDataSource(
      firestoreService: getIt<FirestoreService>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<PersonalInfoRemoteDataSource>(
    () => FirebasePersonalInfoRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
      firebaseFunctions: getIt<FirebaseFunctions>(),
    ),
  );

  getIt.registerLazySingleton<MySubscriptionRemoteDataSource>(
    () => FirebaseMySubscriptionRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<StudentProfileRepository>(
    () => StudentProfileRepositoryImpl(
      dataSource: getIt<StudentProfileDataSource>(),
    ),
  );

  getIt.registerLazySingleton<PersonalInfoRepository>(
    () => PersonalInfoRepositoryImpl(
      remoteDataSource: getIt<PersonalInfoRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<MySubscriptionRepository>(
    () => MySubscriptionRepositoryImpl(
      remoteDataSource: getIt<MySubscriptionRemoteDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<StreamStudentProfileUseCase>(
    () => StreamStudentProfileUseCase(
      repository: getIt<StudentProfileRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetPersonalInfoUseCase>(
    () => GetPersonalInfoUseCase(repository: getIt<PersonalInfoRepository>()),
  );

  getIt.registerLazySingleton<UpdatePersonalInfoUseCase>(
    () =>
        UpdatePersonalInfoUseCase(repository: getIt<PersonalInfoRepository>()),
  );

  getIt.registerLazySingleton<StreamMySubscriptionUseCase>(
    () => StreamMySubscriptionUseCase(
      repository: getIt<MySubscriptionRepository>(),
    ),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      streamStudentProfileUseCase: getIt<StreamStudentProfileUseCase>(),
    ),
  );

  getIt.registerFactory<PersonalInfoCubit>(
    () => PersonalInfoCubit(
      getPersonalInfoUseCase: getIt<GetPersonalInfoUseCase>(),
      updatePersonalInfoUseCase: getIt<UpdatePersonalInfoUseCase>(),
    ),
  );

  getIt.registerFactory<MySubscriptionCubit>(
    () => MySubscriptionCubit(
      streamMySubscriptionUseCase: getIt<StreamMySubscriptionUseCase>(),
    ),
  );
}
