import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:al_waleed/features/live_session/domain/repo/live_session_repo.dart';
import 'package:dartz/dartz.dart';

class LiveSessionUseCase {
  final LiveSessionRepo liveSessionRepo;

  const LiveSessionUseCase({required this.liveSessionRepo});

  Future<Either<AppErrorModel, LiveSessionEntity>> getLiveSession({
    required String gradeId,
  }) async {
    return await liveSessionRepo.getLiveSession(gradeId: gradeId);
  }
}
