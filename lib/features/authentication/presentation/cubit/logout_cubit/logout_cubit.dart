import 'package:al_waleed/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/unsubscribe_notification_grade_topic_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;
  final UnsubscribeNotificationGradeTopicUseCase
  _unsubscribeNotificationGradeTopicUseCase;

  LogoutCubit({
    required LogoutUseCase logoutUseCase,
    required UnsubscribeNotificationGradeTopicUseCase
    unsubscribeNotificationGradeTopicUseCase,
  }) : _logoutUseCase = logoutUseCase,
       _unsubscribeNotificationGradeTopicUseCase =
           unsubscribeNotificationGradeTopicUseCase,
       super(const LogoutInitial());

  bool _isLoggingOut = false;

  bool get _canEmit => !isClosed;

  Future<void> logout() async {
    if (_isLoggingOut || !_canEmit) {
      return;
    }

    _isLoggingOut = true;

    try {
      emit(const LogoutLoading());

      final unsubscribeResult =
          await _unsubscribeNotificationGradeTopicUseCase();

      if (!_canEmit) {
        return;
      }

      final unsubscribeError = unsubscribeResult.fold(
        (error) => error,
        (_) => null,
      );

      if (unsubscribeError != null) {
        emit(LogoutFailure(error: unsubscribeError));

        return;
      }

      final logoutResult = await _logoutUseCase();

      if (!_canEmit) {
        return;
      }

      logoutResult.fold(
        (error) {
          if (_canEmit) {
            emit(LogoutFailure(error: error));
          }
        },
        (_) {
          if (_canEmit) {
            emit(const LogoutSuccess());
          }
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
