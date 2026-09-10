import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:al_waleed/features/live_session/domain/usecase/live_session_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_session_state.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  final LiveSessionUseCase liveSessionUseCase;

  LiveSessionCubit({required this.liveSessionUseCase})
    : super(LiveSessionInitial());

  Future<void> getLiveSession({required String gradeId}) async {
    emit(LiveSessionLoading());

    final result = await liveSessionUseCase.getLiveSession(gradeId: gradeId);

    result.fold(
      (failure) {
        emit(LiveSessionFailure(errorMessage: failure.message));
      },
      (liveSession) {
        final hasAvailableSession =
            liveSession.gradeId == gradeId &&
            liveSession.meetingUrl.trim().isNotEmpty;

        if (!hasAvailableSession) {
          emit(LiveSessionEmpty());
          return;
        }

        emit(LiveSessionSuccess(liveSessionEntity: liveSession));
      },
    );
  }
}
