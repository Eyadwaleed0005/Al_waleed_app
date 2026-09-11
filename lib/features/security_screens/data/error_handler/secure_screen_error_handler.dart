import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:flutter/services.dart';

abstract final class SecureScreenErrorHandler {
  const SecureScreenErrorHandler._();

  static AppErrorModel handle(Object error) {
    if (error is MissingPluginException) {
      return _unsupportedPlatformError();
    }

    if (error is UnsupportedError) {
      return _unsupportedPlatformError();
    }

    if (error is PlatformException) {
      return _handlePlatformException(error);
    }

    return _unknownError();
  }

  static AppErrorModel _handlePlatformException(PlatformException exception) {
    final details = [
      exception.code,
      exception.message,
      exception.details,
    ].whereType<Object>().join(' ').toLowerCase();

    if (_containsAny(details, const [
      'unsupported',
      'unimplemented',
      'not supported',
      'missing plugin',
    ])) {
      return _unsupportedPlatformError();
    }

    if (_containsAny(details, const ['permission', 'denied', 'not allowed'])) {
      return const AppErrorModel(
        code: 'secure-screen-permission-denied',
        message: 'تعذر تفعيل حماية الشاشة بسبب عدم توفر الصلاحية المطلوبة.',
        type: AppErrorType.authorization,
        isRetryable: false,
      );
    }

    if (_containsAny(details, const [
      'unavailable',
      'not available',
      'service unavailable',
    ])) {
      return const AppErrorModel(
        code: 'secure-screen-unavailable',
        message: 'خدمة حماية الشاشة غير متاحة حاليًا.',
        type: AppErrorType.unsupportedPlatform,
        isRetryable: false,
      );
    }

    return AppErrorModel(
      code: exception.code.trim().isEmpty
          ? 'secure-screen-platform-error'
          : exception.code,
      message: 'تعذر تغيير حالة حماية الشاشة.',
      type: AppErrorType.unknown,
      isRetryable: false,
    );
  }

  static AppErrorModel _unsupportedPlatformError() {
    return const AppErrorModel(
      code: 'secure-screen-unsupported-platform',
      message: 'حماية الشاشة غير مدعومة على هذا الجهاز.',
      type: AppErrorType.unsupportedPlatform,
      isRetryable: false,
    );
  }

  static AppErrorModel _unknownError() {
    return const AppErrorModel(
      code: 'secure-screen-unknown',
      message: 'حدث خطأ أثناء تغيير حالة حماية الشاشة.',
      type: AppErrorType.unknown,
      isRetryable: false,
    );
  }

  static bool _containsAny(String source, List<String> values) {
    return values.any(source.contains);
  }
}
