import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/cache/secure_student_grade_local_data_source.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/cache/student_grade_local_data_source.dart';

// Remote data sources
import 'package:al_waleed/features/main_navigation/data/data_sources/remote/firebase_student_grade_remote_data_source.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/remote/student_grade_remote_data_source.dart';

// Repository implementation
import 'package:al_waleed/features/main_navigation/data/repositories/student_grade_repository_impl.dart';

// Repository contract
import 'package:al_waleed/features/main_navigation/domain/repositories/student_grade_repository.dart';

// Use cases
import 'package:al_waleed/features/main_navigation/domain/use_case/stream_student_grade_id_use_case.dart';

// Cubits
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/student_grade_sync_cubit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

void registerMainNavigationDependencies(GetIt getIt) {
  _registerDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerDataSources(GetIt getIt) {
  getIt.registerLazySingleton<StudentGradeLocalDataSource>(
    () => const SecureStudentGradeLocalDataSource(),
  );

  getIt.registerLazySingleton<StudentGradeRemoteDataSource>(
    () => FirebaseStudentGradeRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<StudentGradeRepository>(
    () => StudentGradeRepositoryImpl(
      remoteDataSource: getIt<StudentGradeRemoteDataSource>(),
      localDataSource: getIt<StudentGradeLocalDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<StreamStudentGradeIdUseCase>(
    () => StreamStudentGradeIdUseCase(
      repository: getIt<StudentGradeRepository>(),
    ),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<BottomNavigationCubit>(BottomNavigationCubit.new);

  getIt.registerFactory<StudentGradeSyncCubit>(
    () => StudentGradeSyncCubit(
      streamStudentGradeIdUseCase: getIt<StreamStudentGradeIdUseCase>(),
    ),
  );
}
