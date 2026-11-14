import 'package:al_waleed/core/constants/const.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccountWhatsAppText extends StatefulWidget {
  const CreateAccountWhatsAppText({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  State<CreateAccountWhatsAppText> createState() =>
      _CreateAccountWhatsAppTextState();
}

class _CreateAccountWhatsAppTextState extends State<CreateAccountWhatsAppText> {
  bool _isOpening = false;

  Future<void> _openWhatsApp() async {
    if (widget.isLoading || _isOpening) {
      return;
    }

    setState(() => _isOpening = true);

    final uri = Uri.https('wa.me', '/${Const.teacherWhatsAppNumber}', {
      'text': Const.createAccountMessage,
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
    return TextButton(
      onPressed: widget.isLoading || _isOpening ? null : _openWhatsApp,
      child: Text(
        'عاوز تعمل حساب؟ تواصل مع المدرس',
        textAlign: TextAlign.center,
        style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
          color: widget.isLoading || _isOpening
              ? ColorPalette.textMuted
              : ColorPalette.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
