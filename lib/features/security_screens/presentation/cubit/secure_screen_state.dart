import 'package:al_waleed/core/errors/error_model/app_error_model.dart';

sealed class SecureScreenState {
  const SecureScreenState();
}

final class SecureScreenInitial extends SecureScreenState {
  const SecureScreenInitial();
}

final class SecureScreenLoading extends SecureScreenState {
  const SecureScreenLoading();
}

final class SecureScreenEnabled extends SecureScreenState {
  const SecureScreenEnabled();
}

final class SecureScreenDisabled extends SecureScreenState {
  const SecureScreenDisabled();
}

final class SecureScreenFailure extends SecureScreenState {
  final AppErrorModel error;

  const SecureScreenFailure({
    required this.error,
  });
}