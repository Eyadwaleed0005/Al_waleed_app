import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/cache/student_grade_local_data_source.dart';
import 'package:al_waleed/features/main_navigation/data/data_sources/remote/student_grade_remote_data_source.dart';
import 'package:al_waleed/features/main_navigation/domain/repositories/student_grade_repository.dart';
import 'package:dartz/dartz.dart';

class StudentGradeRepositoryImpl implements StudentGradeRepository {
  const StudentGradeRepositoryImpl({
    required StudentGradeRemoteDataSource remoteDataSource,
    required StudentGradeLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final StudentGradeRemoteDataSource _remoteDataSource;
  final StudentGradeLocalDataSource _localDataSource;

  @override
  Stream<Either<AppErrorModel, String>> streamStudentGradeId() async* {
    try {
      await for (final remoteGradeId in _remoteDataSource.streamGradeId()) {
        final normalizedGradeId = remoteGradeId.trim();

        if (normalizedGradeId.isEmpty) {
          yield Left(LocalStorageErrorHandler.dataNotFound());
          return;
        }

        final syncResult = await _syncGradeId(gradeId: normalizedGradeId);

        yield syncResult.fold(Left.new, (_) => Right(normalizedGradeId));

        if (syncResult.isLeft()) {
          return;
        }
      }
    } on FirebaseRemoteException catch (error) {
      yield Left(error.errorModel);
    } catch (error) {
      yield Left(FirebaseErrorHandler.handle(error));
    }
  }

  Future<Either<AppErrorModel, void>> _syncGradeId({
    required String gradeId,
  }) async {
    try {
      final cachedGradeId = await _localDataSource.getGradeId();
      final normalizedCachedGradeId = cachedGradeId?.trim();

      if (normalizedCachedGradeId == gradeId) {
        return const Right(null);
      }

      await _localDataSource.saveGradeId(gradeId: gradeId);

      return const Right(null);
    } catch (error) {
      return Left(LocalStorageErrorHandler.handle(error));
    }
  }
}
