part of 'live_session_cubit.dart';

sealed class LiveSessionState extends Equatable {
  const LiveSessionState();

  @override
  List<Object> get props => [];
}

final class LiveSessionInitial extends LiveSessionState {}

final class LiveSessionLoading extends LiveSessionState {}

final class LiveSessionSuccess extends LiveSessionState {
  final LiveSessionEntity liveSessionEntity;

  const LiveSessionSuccess({required this.liveSessionEntity});
  @override
  List<Object> get props => [liveSessionEntity];
}
final class LiveSessionEmpty extends LiveSessionState {}

final class LiveSessionFailure extends LiveSessionState {
  final String errorMessage;

  const LiveSessionFailure({required this.errorMessage});
   @override
  List<Object> get props => [errorMessage];
}
