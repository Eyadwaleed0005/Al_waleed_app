import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';

class OnboardingBackButton extends StatelessWidget {
  const OnboardingBackButton({
    super.key,
    required this.isVisible,
    required this.onPressed,
  });

  final bool isVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'رجوع',
          style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
            color: ColorPalette.textSoftSaga,
          ),
        ),
      ),
    );
  }
}
