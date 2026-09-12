import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:flutter/material.dart';

class SplashSubscriptionExpiredDialog extends StatelessWidget {
  const SplashSubscriptionExpiredDialog({
    super.key,
    required this.onRetryPressed,
    required this.onCloseAppPressed,
  });

  final VoidCallback onRetryPressed;
  final VoidCallback onCloseAppPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CustomOperationResultDialog(
        type: CustomOperationResultType.failure,
        failureIcon: Icons.event_busy_rounded,
        title: 'انتهى اشتراك الحساب',
        message:
            'انتهت صلاحية اشتراك هذا الحساب. تواصل مع المعلم لتجديد الاشتراك، ثم اضغط على إعادة المحاولة.',
        actionText: 'إعادة المحاولة',
        secondaryActionText: 'إغلاق التطبيق',
        onActionPressed: onRetryPressed,
        onSecondaryActionPressed: onCloseAppPressed,
      ),
    );
  }
}
