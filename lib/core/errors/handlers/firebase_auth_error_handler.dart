import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract final class FirebaseAuthErrorHandler {
  const FirebaseAuthErrorHandler._();

  static const String subscriptionExpiredCode = 'subscription-expired';

  static const String deviceAlreadyLoggedInCode = 'device-already-logged-in';

  static const String studentRecordNotFoundCode = 'student-record-not-found';

  static const String missingGradeIdCode = 'missing-grade-id';

  static const String authenticatedUserNotFoundCode =
      'authenticated-user-not-found';

  static AppErrorModel handle(FirebaseAuthException error) {
    return handleCode(error.code);
  }

  static AppErrorModel handleCode(String errorCode) {
    final code = _normalizeCode(errorCode);

    switch (code) {
      case 'invalid-email':
        return _error(
          code: code,
          message: 'صيغة البريد الإلكتروني غير صحيحة.',
          type: AppErrorType.validation,
        );

      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return _error(
          code: code,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
          type: AppErrorType.authentication,
        );

      case 'user-disabled':
        return _error(
          code: code,
          message: 'تم إيقاف هذا الحساب. تواصل مع إدارة المنصة.',
          type: AppErrorType.authorization,
        );

      case subscriptionExpiredCode:
        return _error(
          code: code,
          message: 'اشتراك هذا الحساب انتهى. تواصل مع المنصة للتجديد.',
          type: AppErrorType.authorization,
        );

      case deviceAlreadyLoggedInCode:
        return _error(
          code: code,
          message: 'هذا الحساب مفتوح على جهاز آخر. تواصل مع المنصة لفك الربط.',
          type: AppErrorType.conflict,
        );

      case studentRecordNotFoundCode:
        return _error(
          code: code,
          message:
              'بيانات الطالب غير موجودة. تواصل مع إدارة المنصة لمراجعة الحساب.',
          type: AppErrorType.notFound,
        );

      case missingGradeIdCode:
        return _error(
          code: code,
          message:
              'لم يتم تحديد الصف الدراسي لهذا الحساب. تواصل مع إدارة المنصة.',
          type: AppErrorType.server,
        );

      case authenticatedUserNotFoundCode:
        return _error(
          code: code,
          message:
              'تعذر الوصول إلى بيانات الحساب بعد تسجيل الدخول. حاول مرة أخرى.',
          type: AppErrorType.authentication,
          isRetryable: true,
        );

      case 'network-request-failed':
      case 'network-error':
        return _error(
          code: code,
          message:
              'تعذر الاتصال بالخدمة. تحقق من اتصال الإنترنت وحاول مرة أخرى.',
          type: AppErrorType.network,
          isRetryable: true,
        );

      case 'too-many-requests':
        return _error(
          code: code,
          message:
              'تم إجراء محاولات تسجيل دخول كثيرة. انتظر قليلًا ثم حاول مرة أخرى.',
          type: AppErrorType.rateLimit,
          isRetryable: true,
        );

      case 'operation-not-allowed':
        return _error(
          code: code,
          message: 'تسجيل الدخول غير متاح حاليًا. تواصل مع إدارة المنصة.',
          type: AppErrorType.server,
        );

      case 'internal-error':
        return _error(
          code: code,
          message: 'حدث خطأ أثناء تسجيل الدخول. حاول مرة أخرى.',
          type: AppErrorType.server,
          isRetryable: true,
        );

      default:
        return _error(
          code: code,
          message: 'تعذر إتمام عملية تسجيل الدخول. حاول مرة أخرى.',
          type: AppErrorType.authentication,
          isRetryable: true,
        );
    }
  }

  static AppErrorModel _error({
    required String code,
    required String message,
    required AppErrorType type,
    bool isRetryable = false,
  }) {
    return AppErrorModel(
      code: code,
      message: message,
      type: type,
      isRetryable: isRetryable,
    );
  }

  static String _normalizeCode(String code) {
    return code
        .trim()
        .toLowerCase()
        .replaceFirst('firebase_auth/', '')
        .replaceFirst('auth/', '')
        .replaceAll('_', '-');
  }
}
