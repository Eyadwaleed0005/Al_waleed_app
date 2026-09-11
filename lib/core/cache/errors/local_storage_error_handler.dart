import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:flutter/services.dart';

abstract final class LocalStorageErrorHandler {
  const LocalStorageErrorHandler._();

  static AppErrorModel handle(Object error) {
    if (error is TimeoutException) {
      return _timeoutError();
    }

    if (error is FormatException) {
      return _invalidDataError();
    }

    if (error is MissingPluginException) {
      return _serviceUnavailableError();
    }

    if (error is PlatformException) {
      return _handlePlatformException(error);
    }

    return _unknownError();
  }

  static AppErrorModel dataNotFound() {
    return const AppErrorModel(
      code: 'local-data-not-found',
      message: 'البيانات المحفوظة المطلوبة غير موجودة.',
      type: AppErrorType.notFound,
      isRetryable: false,
    );
  }

  static AppErrorModel _handlePlatformException(PlatformException exception) {
    final errorDetails = [
      exception.code,
      exception.message,
      exception.details,
    ].whereType<Object>().join(' ').toLowerCase();

    if (_containsAny(errorDetails, const [
      'not found',
      'not_found',
      'key not found',
      'item not found',
    ])) {
      return dataNotFound();
    }

    if (_containsAny(errorDetails, const [
      'keystore',
      'keychain',
      'decrypt',
      'decryption',
      'encrypt',
      'encryption',
      'invalid key',
      'bad padding',
      'security',
    ])) {
      return const AppErrorModel(
        code: 'secure-storage-access-error',
        message: 'تعذر الوصول إلى بيانات الحساب المحفوظة.',
        type: AppErrorType.unknown,
        isRetryable: false,
      );
    }

    if (_containsAny(errorDetails, const [
      'unavailable',
      'not available',
      'service unavailable',
      'missing plugin',
    ])) {
      return _serviceUnavailableError();
    }

    return const AppErrorModel(
      code: 'local-storage-operation-failed',
      message: 'تعذر قراءة بيانات الحساب المحفوظة، حاول مرة أخرى.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static AppErrorModel _timeoutError() {
    return const AppErrorModel(
      code: 'local-storage-timeout',
      message: 'استغرقت قراءة بيانات الحساب وقتًا أطول من المتوقع.',
      type: AppErrorType.timeout,
      isRetryable: true,
    );
  }

  static AppErrorModel _invalidDataError() {
    return const AppErrorModel(
      code: 'invalid-local-data',
      message: 'بيانات الحساب المحفوظة غير صحيحة.',
      type: AppErrorType.validation,
      isRetryable: false,
    );
  }

  static AppErrorModel _serviceUnavailableError() {
    return const AppErrorModel(
      code: 'local-storage-unavailable',
      message: 'خدمة حفظ بيانات الحساب غير متاحة حاليًا.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static AppErrorModel _unknownError() {
    return const AppErrorModel(
      code: 'local-storage-unknown',
      message: 'تعذر الوصول إلى بيانات الحساب المحفوظة.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static bool _containsAny(String source, List<String> values) {
    return values.any(source.contains);
  }
}
