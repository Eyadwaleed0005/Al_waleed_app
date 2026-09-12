import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/app_startup/domain/entities/app_startup_destination.dart';
import 'package:flutter/material.dart';

class SplashUpdateDialog extends StatelessWidget {
  const SplashUpdateDialog({
    super.key,
    required this.destination,
    required this.onUpdatePressed,
    this.onContinuePressed,
  });

  final AppStartupUpdateDestination destination;
  final VoidCallback onUpdatePressed;
  final VoidCallback? onContinuePressed;

  @override
  Widget build(BuildContext context) {
    final isForcedUpdate = destination.isForced;

    return PopScope(
      canPop: false,
      child: CustomOperationResultDialog(
        type: CustomOperationResultType.success,
        successIcon: Icons.system_update_alt_rounded,
        title: isForcedUpdate ? 'تحديث التطبيق مطلوب' : 'يتوفر تحديث جديد',
        message: isForcedUpdate
            ? 'يتوفر إصدار جديد من التطبيق، ويجب تثبيت التحديث حتى تتمكن من المتابعة.'
            : 'يتوفر إصدار جديد من التطبيق. يمكنك التحديث الآن أو المتابعة بالإصدار الحالي.',
        actionText: 'تحديث التطبيق',
        secondaryActionText: isForcedUpdate ? null : 'لاحقًا',
        onActionPressed: onUpdatePressed,
        onSecondaryActionPressed: isForcedUpdate ? null : onContinuePressed,
      ),
    );
  }
}
