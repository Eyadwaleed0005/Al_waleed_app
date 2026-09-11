part of 'profile_cubit.dart';

sealed class ProfileState {}

class GetProfileInitial extends ProfileState {}

class GetProfileLoading extends ProfileState {}

class GetProfileSuccess extends ProfileState {
  final ProfileEntity profile;
  GetProfileSuccess({required this.profile});
}

class GetProfileFailure extends ProfileState {
  final String errorMsg;
  GetProfileFailure({required this.errorMsg});
}

class LogoutInitial extends ProfileState {}

class LogoutLoading extends ProfileState {
  final ProfileEntity profile;

  LogoutLoading({required this.profile});
}

class LogoutSuccess extends ProfileState {}

class LogoutFailure extends ProfileState {
  final String errorMsg;
  final ProfileEntity profile;
  LogoutFailure({required this.errorMsg, required this.profile});
}
