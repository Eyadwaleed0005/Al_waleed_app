import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamNavigationActions extends StatelessWidget {
  const ExamNavigationActions({
    super.key,
    this.onPreviousPressed,
    this.onNextPressed,
    this.onSubmitPressed,
    this.isSubmitting = false,
  });

  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback? onSubmitPressed;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'التالي',
                onPressed: isSubmitting ? null : onNextPressed,
                background: ColorPalette.primary,
                foreground: ColorPalette.textLight,
                height: 50.h,
              ),
            ),
            horizontalSpace(14),
            Expanded(
              child: CustomSecondaryButton(
                text: 'السابق',
                onPressed: isSubmitting ? null : onPreviousPressed,
                backgroundColor: ColorPalette.surface,
                borderColor: ColorPalette.softSage,
                foregroundColor: ColorPalette.primary,
                height: 50.h,
              ),
            ),
          ],
        ),
        verticalSpace(12),
        CustomSecondaryButton(
          text: 'تسليم الامتحان',
          onPressed: isSubmitting ? null : onSubmitPressed,
          isLoading: isSubmitting,
          backgroundColor: ColorPalette.surface,
          borderColor: ColorPalette.crimsonRed.withValues(alpha: 0.4),
          foregroundColor: ColorPalette.crimsonRed,
          height: 50.h,
        ),
      ],
    );
  }
}
