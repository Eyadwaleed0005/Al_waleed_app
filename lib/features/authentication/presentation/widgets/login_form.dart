import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:al_waleed/features/authentication/presentation/validation/login_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {}
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            labelText: 'البريد الإلكتروني',
            hintText: 'example@email.com',
            controller: _emailController,
            validator: LoginValidation.email,
          ),
          verticalSpace(16),
          CustomTextFormField(
            labelText: 'كلمة المرور',
            hintText: 'أدخل كلمة المرور',
            controller: _passwordController,
            obscureText: _isObscure,
            validator: LoginValidation.password,
            prefixIcon: IconButton(
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _isObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: ColorPalette.textMuted,
              ),
            ),
          ),
          verticalSpace(24),
          CustomButton(text: 'تسجيل الدخول', onPressed: _submit),
          verticalSpace(16),
          CustomSecondaryButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '.نسيت كلمة المرور؟ تواصل مع المدرس',
                  style: AppTextStyle.font12TextSecondaryRegularTajawal(),
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
          ),
        ],
      ),
    );
  }
}
