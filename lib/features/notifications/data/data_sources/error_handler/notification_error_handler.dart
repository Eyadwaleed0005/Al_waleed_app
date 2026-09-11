import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

abstract final class NotificationErrorHandler {
  const NotificationErrorHandler._();

  static AppErrorModel handle(Object error) {
    if (error is FirebaseRemoteException) {
      return error.errorModel;
    }

    if (error is FirebaseException) {
      return _handleFirebaseException(error);
    }

    if (error is MissingPluginException) {
      return const AppErrorModel(
        code: 'notification-service-unavailable',
        message: 'خدمة الإشعارات غير متاحة على هذا الجهاز.',
        type: AppErrorType.unsupportedPlatform,
        isRetryable: false,
      );
    }

    if (error is PlatformException) {
      return _handlePlatformException(error);
    }

    if (error is TimeoutException) {
      return const AppErrorModel(
        code: 'notification-timeout',
        message: 'استغرقت عملية الإشعارات وقتًا أطول من المتوقع.',
        type: AppErrorType.timeout,
        isRetryable: true,
      );
    }

    if (error is FormatException || error is ArgumentError) {
      return invalidGradeId();
    }

    return const AppErrorModel(
      code: 'notification-unknown',
      message: 'حدث خطأ أثناء إعداد الإشعارات، حاول مرة أخرى.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static AppErrorModel invalidGradeId() {
    return const AppErrorModel(
      code: 'invalid-notification-grade-id',
      message: 'تعذر تحديد الصف الدراسي الخاص بالإشعارات.',
      type: AppErrorType.validation,
      isRetryable: false,
    );
  }

  static AppErrorModel _handleFirebaseException(FirebaseException exception) {
    final code = _normalizeCode(exception.code);
    final message = (exception.message ?? '').toLowerCase();

    if (_isNetworkError(code: code, message: message)) {
      return const AppErrorModel(
        code: 'notification-no-internet',
        message: 'لا يوجد اتصال بالإنترنت لإعداد الإشعارات.',
        type: AppErrorType.network,
        isRetryable: true,
      );
    }

    switch (code) {
      case 'permission-denied':
      case 'unauthorized':
        return const AppErrorModel(
          code: 'notification-permission-denied',
          message: 'لم يتم السماح للتطبيق بإرسال الإشعارات.',
          type: AppErrorType.authorization,
          isRetryable: false,
        );

      case 'invalid-argument':
      case 'invalid-topic-name':
        return const AppErrorModel(
          code: 'invalid-notification-topic',
          message: 'بيانات الاشتراك في إشعارات الصف غير صحيحة.',
          type: AppErrorType.validation,
          isRetryable: false,
        );

      case 'too-many-topics':
        return const AppErrorModel(
          code: 'too-many-notification-topics',
          message: 'تعذر الاشتراك في إشعارات الصف حاليًا.',
          type: AppErrorType.rateLimit,
          isRetryable: false,
        );

      case 'unavailable':
      case 'internal':
      case 'server-unavailable':
        return const AppErrorModel(
          code: 'notification-server-unavailable',
          message: 'خدمة الإشعارات غير متاحة حاليًا، حاول مرة أخرى.',
          type: AppErrorType.server,
          isRetryable: true,
        );

      default:
        return AppErrorModel(
          code: code.isEmpty ? 'notification-firebase-error' : code,
          message: 'تعذر تنفيذ عملية الإشعارات، حاول مرة أخرى.',
          type: AppErrorType.unknown,
          isRetryable: true,
        );
    }
  }

  static AppErrorModel _handlePlatformException(PlatformException exception) {
    final code = _normalizeCode(exception.code);
    final message = (exception.message ?? '').toLowerCase();

    if (_isNetworkError(code: code, message: message)) {
      return const AppErrorModel(
        code: 'notification-no-internet',
        message: 'لا يوجد اتصال بالإنترنت لإعداد الإشعارات.',
        type: AppErrorType.network,
        isRetryable: true,
      );
    }

    if (code.contains('permission') || message.contains('permission')) {
      return const AppErrorModel(
        code: 'notification-permission-denied',
        message: 'لم يتم السماح للتطبيق بإرسال الإشعارات.',
        type: AppErrorType.authorization,
        isRetryable: false,
      );
    }

    return AppErrorModel(
      code: code.isEmpty ? 'notification-platform-error' : code,
      message: 'تعذر تشغيل خدمة الإشعارات على الجهاز.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }

  static bool _isNetworkError({required String code, required String message}) {
    return code.contains('network') ||
        code == 'unavailable' ||
        message.contains('network') ||
        message.contains('offline') ||
        message.contains('no internet') ||
        message.contains('failed to connect');
  }

  static String _normalizeCode(String code) {
    return code
        .trim()
        .toLowerCase()
        .replaceFirst('firebase_messaging/', '')
        .replaceFirst('messaging/', '')
        .replaceAll('_', '-');
  }
}
