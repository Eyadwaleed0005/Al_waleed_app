import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:flutter/services.dart';

abstract final class LocalStorageErrorCodes {
  const LocalStorageErrorCodes._();

  static const String dataNotFound = 'local-data-not-found';

  static const String invalidData = 'invalid-local-data';

  static const String operationNotAllowed = 'local-operation-not-allowed';
}

final class LocalStorageException implements Exception {
  const LocalStorageException(this.code);

  final String code;
}

abstract final class LocalStorageErrorHandler {
  const LocalStorageErrorHandler._();

  static AppErrorModel handle(Object error) {
    if (error is LocalStorageException) {
      return handleCode(error.code);
    }

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

  static AppErrorModel handleCode(String errorCode) {
    final String code = errorCode.trim().toLowerCase();

    return switch (code) {
      LocalStorageErrorCodes.dataNotFound => dataNotFound(),
      LocalStorageErrorCodes.invalidData => _invalidDataError(),
      LocalStorageErrorCodes.operationNotAllowed => _operationNotAllowedError(),
      _ => _unknownError(),
    };
  }

  static Never throwDataNotFound() {
    throw const LocalStorageException(LocalStorageErrorCodes.dataNotFound);
  }

  static Never throwInvalidData() {
    throw const LocalStorageException(LocalStorageErrorCodes.invalidData);
  }

  static Never throwOperationNotAllowed() {
    throw const LocalStorageException(
      LocalStorageErrorCodes.operationNotAllowed,
    );
  }

  static AppErrorModel dataNotFound() {
    return const AppErrorModel(
      code: LocalStorageErrorCodes.dataNotFound,
      message: 'البيانات المحفوظة المطلوبة غير موجودة.',
      type: AppErrorType.notFound,
      isRetryable: false,
    );
  }

  static AppErrorModel _handlePlatformException(PlatformException exception) {
    final String errorDetails = <Object?>[
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
        message: 'تعذر الوصول إلى البيانات المحفوظة.',
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
      message: 'تعذر الوصول إلى البيانات المحفوظة، حاول مرة أخرى.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static AppErrorModel _operationNotAllowedError() {
    return const AppErrorModel(
      code: LocalStorageErrorCodes.operationNotAllowed,
      message:
          'لا يمكن تعديل الإجابات بعد انتهاء وقت الاختبار أو بدء عملية التسليم.',
      type: AppErrorType.validation,
      isRetryable: false,
    );
  }

  static AppErrorModel _timeoutError() {
    return const AppErrorModel(
      code: 'local-storage-timeout',
      message: 'استغرقت قراءة البيانات وقتًا أطول من المتوقع.',
      type: AppErrorType.timeout,
      isRetryable: true,
    );
  }

  static AppErrorModel _invalidDataError() {
    return const AppErrorModel(
      code: LocalStorageErrorCodes.invalidData,
      message: 'بيانات الاختبار المحفوظة غير صحيحة.',
      type: AppErrorType.validation,
      isRetryable: false,
    );
  }

  static AppErrorModel _serviceUnavailableError() {
    return const AppErrorModel(
      code: 'local-storage-unavailable',
      message: 'خدمة حفظ البيانات غير متاحة حاليًا.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static AppErrorModel _unknownError() {
    return const AppErrorModel(
      code: 'local-storage-unknown',
      message: 'تعذر الوصول إلى البيانات المحفوظة.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static bool _containsAny(String source, List<String> values) {
    return values.any(source.contains);
  }
}
