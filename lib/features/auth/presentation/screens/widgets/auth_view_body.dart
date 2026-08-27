import 'package:al_waleed/core/helper/app_validator.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_button.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/auth/presentation/screens/widgets/custom_auth_logo.dart';
import 'package:al_waleed/features/auth/presentation/screens/widgets/custom_forgot_password.dart';
import 'package:al_waleed/features/auth/presentation/screens/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/style/app_color.dart';

class AuthViewBody extends StatefulWidget {
  const AuthViewBody({super.key});

  @override
  State<AuthViewBody> createState() => _AuthViewBodyState();
}

class _AuthViewBodyState extends State<AuthViewBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            ColorPalette.primaryPressed,
            ColorPalette.primary,
            ColorPalette.primarySoftBackground,
            ColorPalette.highlight,
          ],
          stops: [0.0, 0.4, 0.8, 1.0],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40.h),

                CustomAuthLogo(),

                SizedBox(height: 12.h),
                Text('الوليد', style: AppTextStyle.font26PageTitleBoldKufam()),
                Text(
                  'منصة الكيمياء التعليمية',
                  style: AppTextStyle.font14TextSecondaryRegularTajawal()
                      .copyWith(
                        color: ColorPalette.cardBackground.withValues(
                          alpha: .6,
                        ),
                      ),
                ),

                SizedBox(height: 20.h),

                CustomAppCard(
                  child: Column(
                    children: [
                      Text(
                        'أهلاً بك من جديد',
                        style: AppTextStyle.font20TextBlackSemiBoldKufam(),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '.سجّل دخولك للوصول إلى دروسك واختباراتك',
                        style: AppTextStyle.font14TextBlackRegularTajawal()
                            .copyWith(color: ColorPalette.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),

                      CustomTextFormField(
                        label: 'البريد الإلكتروني',
                        hintText: 'example@email.com',
                        controller: _emailController,
                        validator: AppValidator.email,
                      ),
                      SizedBox(height: 16.h),

                      CustomTextFormField(
                        label: 'كلمة المرور',
                        hintText: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        isObscureText: _isObscure,
                        validator: AppValidator.strongPassword,
                        prefixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: ColorPalette.textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),

                      CustomAppButton(text: 'تسجيل الدخول', onPressed: _submit),
                      SizedBox(height: 16.h),

                      CustomForgotpassword(),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
