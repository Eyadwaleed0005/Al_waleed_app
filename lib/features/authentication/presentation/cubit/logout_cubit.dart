import 'package:al_waleed/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;

  LogoutCubit({required LogoutUseCase logoutUseCase})
    : _logoutUseCase = logoutUseCase,
      super(const LogoutInitial());

  bool _isLoggingOut = false;

  Future<void> logout() async {
    if (_isLoggingOut || isClosed) return;

    _isLoggingOut = true;

    try {
      emit(const LogoutLoading());

      final result = await _logoutUseCase();

      if (isClosed) return;

      result.fold(
        (error) {
          if (isClosed) return;

          emit(LogoutFailure(error: error));
        },
        (_) {
          if (isClosed) return;

          emit(const LogoutSuccess());
        },
      );
    } finally {
      _isLoggingOut = false;
    }
  }

  Future<void> retry() {
    return logout();
  }
}
