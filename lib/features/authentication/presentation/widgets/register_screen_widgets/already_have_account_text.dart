import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: Text(
        'لديك حساب بالفعل؟ تسجيل الدخول',
        style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
          color: ColorPalette.primary,
        ),
      ),
    );
  }
}
