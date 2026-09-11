import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/live_session/data/data_source/live_session_remote_data_source.dart';
import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:al_waleed/features/live_session/domain/repo/live_session_repo.dart';
import 'package:dartz/dartz.dart';

class LiveSessionRepoImpl implements LiveSessionRepo {
  final LiveSessionRemoteDataSource liveSessionRemoteDataSource;

  LiveSessionRepoImpl({required this.liveSessionRemoteDataSource});

  @override
  Future<Either<AppErrorModel, LiveSessionEntity>> getLiveSession({
    required String gradeId,
  }) async {
    try {
      final session = await liveSessionRemoteDataSource.getLiveSession(
        gradeId: gradeId,
      );
      return right(session);
    } on FirebaseRemoteException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(FirebaseErrorHandler.handle(e));
    }
  }
}
