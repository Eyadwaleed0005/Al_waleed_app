import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LiveSessionRepo {
  Future<Either<AppErrorModel, LiveSessionEntity>> getLiveSession(
    {required String gradeId}
  );
}
