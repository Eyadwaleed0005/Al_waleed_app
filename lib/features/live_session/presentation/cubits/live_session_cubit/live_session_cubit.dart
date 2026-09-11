import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:al_waleed/features/live_session/domain/usecase/live_session_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_session_state.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  final LiveSessionUseCase liveSessionUseCase;

  LiveSessionCubit({required this.liveSessionUseCase})
    : super(LiveSessionInitial());

  bool _isClosing = false;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> getLiveSession({required String gradeId}) async {
    if (!_canEmit) return;

    emit(LiveSessionLoading());

    final normalizedGradeId = gradeId.trim();

    final result = await liveSessionUseCase.getLiveSession(
      gradeId: normalizedGradeId,
    );

    if (!_canEmit) return;

    result.fold(
      (failure) {
        if (!_canEmit) return;

        emit(LiveSessionFailure(errorMessage: failure.message));
      },
      (liveSession) {
        if (!_canEmit) return;

        final hasAvailableSession =
            liveSession.gradeId.trim() == normalizedGradeId &&
            liveSession.meetingUrl.trim().isNotEmpty;

        if (!hasAvailableSession) {
          emit(LiveSessionEmpty());
          return;
        }

        emit(LiveSessionSuccess(liveSessionEntity: liveSession));
      },
    );
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;

    await super.close();
  }
}
