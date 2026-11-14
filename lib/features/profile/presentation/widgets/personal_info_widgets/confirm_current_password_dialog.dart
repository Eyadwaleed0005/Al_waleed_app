import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ConfirmCurrentPasswordDialog extends StatefulWidget {
  const ConfirmCurrentPasswordDialog({super.key});

  @override
  State<ConfirmCurrentPasswordDialog> createState() =>
      _ConfirmCurrentPasswordDialogState();
}

class _ConfirmCurrentPasswordDialogState
    extends State<ConfirmCurrentPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.of(context).pop<String>(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return CustomOperationResultDialog(
      type: CustomOperationResultType.success,
      successIcon: Icons.lock_outline_rounded,
      title: 'تأكيد هويتك',
      message:
          'أدخل كلمة المرور الحالية لحسابك '
          'لتأكيد طلب تغيير البريد الإلكتروني.',
      actionText: 'تأكيد ومتابعة',
      secondaryActionText: 'إلغاء',
      onActionPressed: _confirm,
      content: Form(
        key: _formKey,
        child: CustomTextFormField(
          controller: _passwordController,
          labelText: 'كلمة المرور الحالية',
          hintText: 'أدخل كلمة المرور الحالية',
          obscureText: _isObscure,
          isPassword: true,
          showPasswordCopyIcon: false,
          textDirection: TextDirection.ltr,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'من فضلك اكتب كلمة المرور الحالية';
            }

            return null;
          },
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: Icon(
              _isObscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: ColorPalette.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
