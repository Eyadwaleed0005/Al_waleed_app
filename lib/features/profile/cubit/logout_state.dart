part of 'logout_cubit.dart';

sealed class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutFailure extends LogoutState {
  final String errorMsg;
  LogoutFailure({required this.errorMsg});
}
