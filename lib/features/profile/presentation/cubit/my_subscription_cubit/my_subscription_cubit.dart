import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/profile/domain/entities/my_subscription_entity.dart';
import 'package:al_waleed/features/profile/domain/usecase/stream_my_subscription_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'my_subscription_state.dart';

class MySubscriptionCubit extends Cubit<MySubscriptionState> {
  MySubscriptionCubit({required this._streamMySubscriptionUseCase})
    : super(const MySubscriptionInitial());

  final StreamMySubscriptionUseCase _streamMySubscriptionUseCase;

  StreamSubscription<Either<AppErrorModel, MySubscriptionEntity>>?
  _subscription;

  bool _isInitializing = false;
  bool _isClosing = false;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> initialize() async {
    if (_isInitializing || !_canEmit) return;

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (!_canEmit) return;

      emit(const MySubscriptionLoading());

      _subscription = _streamMySubscriptionUseCase().listen(
        _onSubscriptionResult,
        onError: _onStreamError,
      );
    } catch (error) {
      _emitFailure(FirebaseErrorHandler.handle(error));
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void _onSubscriptionResult(
    Either<AppErrorModel, MySubscriptionEntity> result,
  ) {
    if (!_canEmit) return;

    result.fold(_emitFailure, (subscription) {
      emit(MySubscriptionSuccess(subscription: subscription));
    });
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    _emitFailure(FirebaseErrorHandler.handle(error));
  }

  void _emitFailure(AppErrorModel error) {
    if (!_canEmit) return;

    emit(MySubscriptionFailure(error: error));
  }

  Future<void> _cancelSubscription() async {
    final subscription = _subscription;
    _subscription = null;

    await subscription?.cancel();
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;

    try {
      await _cancelSubscription();
    } finally {
      await super.close();
    }
  }
}
