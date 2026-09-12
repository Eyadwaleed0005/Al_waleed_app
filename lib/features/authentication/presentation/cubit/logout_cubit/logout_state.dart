import 'package:al_waleed/core/errors/error_model/app_error_model.dart';

sealed class LogoutState {
  const LogoutState();
}

final class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

final class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

final class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

final class LogoutFailure extends LogoutState {
  final AppErrorModel error;

  const LogoutFailure({required this.error});
}
