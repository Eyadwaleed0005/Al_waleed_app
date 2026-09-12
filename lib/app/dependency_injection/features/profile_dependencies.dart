import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';

// Data sources
import 'package:al_waleed/features/profile/data/datasource/firebase_student_profile_data_source.dart';
import 'package:al_waleed/features/profile/data/datasource/student_profile_data_source.dart';

// Repository implementation
import 'package:al_waleed/features/profile/data/repositories/student_profile_repositoy_impl.dart';

// Repository contract
import 'package:al_waleed/features/profile/domain/repositories/student_profile_repository.dart';

// Use cases
import 'package:al_waleed/features/profile/domain/usecase/stream_student_profile_use_case.dart';

// Cubits
import 'package:al_waleed/features/profile/presentation/cubit/profile_cubit.dart';

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
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<StudentProfileRepository>(
    () => StudentProfileRepositoryImpl(
      dataSource: getIt<StudentProfileDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<StreamStudentProfileUseCase>(
    () => StreamStudentProfileUseCase(
      repository: getIt<StudentProfileRepository>(),
    ),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      streamStudentProfileUseCase: getIt<StreamStudentProfileUseCase>(),
    ),
  );
}
