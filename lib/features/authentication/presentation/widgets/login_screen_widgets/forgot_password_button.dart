import 'package:al_waleed/core/constants/const.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordButton extends StatefulWidget {
  const ForgotPasswordButton({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  State<ForgotPasswordButton> createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
  bool _isOpening = false;

  Future<void> _openWhatsApp() async {
    if (widget.isLoading || _isOpening) {
      return;
    }

    setState(() => _isOpening = true);

    final uri = Uri.https('wa.me', '/${Const.teacherWhatsAppNumber}', {
      'text': Const.forgotPasswordMessage,
    });

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        _showError();
      }
    } catch (_) {
      _showError();
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  void _showError() {
    if (!mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تعذّر فتح رابط واتساب، حاول مرة أخرى.',
      icon: Icons.error_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomSecondaryButton(
      onPressed: widget.isLoading || _isOpening ? null : _openWhatsApp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'نسيت كلمة المرور؟ تواصل مع المدرس',
              textAlign: TextAlign.center,
              style: AppTextStyle.font12TextSecondaryRegularTajawal(),
            ),
          ),
          horizontalSpace(9),
          CircleAvatar(
            radius: 10.r,
            backgroundColor: ColorPalette.accent,
            child: Text(
              '؟',
              style: AppTextStyle.font14TextPrimaryMediumKufam(),
            ),
          ),
        ],
      ),
    );
  }
}
