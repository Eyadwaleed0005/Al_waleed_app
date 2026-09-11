import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/security_screens/domain/use_case/disable_secure_screen_use_case.dart';
import 'package:al_waleed/features/security_screens/domain/use_case/enable_secure_screen_use_case.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecureScreenCubit extends Cubit<SecureScreenState> {
  final EnableSecureScreenUseCase _enableSecureScreenUseCase;
  final DisableSecureScreenUseCase _disableSecureScreenUseCase;

  SecureScreenCubit({
    required EnableSecureScreenUseCase enableSecureScreenUseCase,
    required DisableSecureScreenUseCase disableSecureScreenUseCase,
  }) : _enableSecureScreenUseCase = enableSecureScreenUseCase,
       _disableSecureScreenUseCase = disableSecureScreenUseCase,
       super(const SecureScreenInitial());

  int _activeProtectedScreens = 0;

  bool _isProtectionEnabled = false;
  bool _isClosing = false;

  Future<void> _operationQueue = Future<void>.value();

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> acquireProtection() {
    if (!_canEmit) {
      return Future<void>.value();
    }

    _activeProtectedScreens++;

    return _enqueue(_synchronizeProtection);
  }

  Future<void> releaseProtection() {
    if (!_canEmit) {
      return Future<void>.value();
    }

    if (_activeProtectedScreens > 0) {
      _activeProtectedScreens--;
    }

    return _enqueue(_synchronizeProtection);
  }

  Future<void> retry() {
    if (!_canEmit) {
      return Future<void>.value();
    }

    return _enqueue(_synchronizeProtection);
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    _operationQueue = _operationQueue.then((_) => operation());

    return _operationQueue;
  }

  Future<void> _synchronizeProtection() async {
    if (!_canEmit) return;

    final shouldEnableProtection = _activeProtectedScreens > 0;

    if (shouldEnableProtection) {
      await _enableProtectionIfNeeded();
      return;
    }

    await _disableProtectionIfNeeded();
  }

  Future<void> _enableProtectionIfNeeded() async {
    if (_isProtectionEnabled) {
      if (_canEmit && state is! SecureScreenEnabled) {
        emit(const SecureScreenEnabled());
      }

      return;
    }

    if (_canEmit) {
      emit(const SecureScreenLoading());
    }

    final result = await _enableSecureScreenUseCase();

    if (!_canEmit) return;

    _handleEnableResult(result);
  }

  void _handleEnableResult(Either<AppErrorModel, void> result) {
    result.fold(
      (error) {
        if (!_canEmit) return;

        _isProtectionEnabled = false;

        emit(SecureScreenFailure(error: error));
      },
      (_) {
        if (!_canEmit) return;

        _isProtectionEnabled = true;

        emit(const SecureScreenEnabled());
      },
    );
  }

  Future<void> _disableProtectionIfNeeded() async {
    if (!_isProtectionEnabled) {
      if (_canEmit && state is! SecureScreenDisabled) {
        emit(const SecureScreenDisabled());
      }

      return;
    }

    final result = await _disableSecureScreenUseCase();

    if (!_canEmit) return;

    result.fold(
      (error) {
        _isProtectionEnabled = true;

        emit(SecureScreenFailure(error: error));
      },
      (_) {
        _isProtectionEnabled = false;

        emit(const SecureScreenDisabled());
      },
    );
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;
    _activeProtectedScreens = 0;

    await _operationQueue;

    if (_isProtectionEnabled) {
      await _disableSecureScreenUseCase();
      _isProtectionEnabled = false;
    }

    await super.close();
  }
}
