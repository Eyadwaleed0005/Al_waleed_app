import 'package:al_waleed/features/live_session/data/models/live_session_model.dart';

abstract class LiveSessionRemoteDataSource {
  Future<LiveSessionModel> getLiveSession({required String gradeId});
}
