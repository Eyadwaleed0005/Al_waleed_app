import 'package:al_waleed/core/helper/app_validator.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:al_waleed/features/auth/presentation/screens/widgets/log_in_background.dart';
import 'package:al_waleed/features/auth/presentation/screens/widgets/log_in_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/style/app_color.dart';

class LogInScreenBody extends StatefulWidget {
  const LogInScreenBody({super.key});

  @override
  State<LogInScreenBody> createState() => _LogInScreenBodyState();
}

class _LogInScreenBodyState extends State<LogInScreenBody> {
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
    return LogInBackground(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40.h),

              CustomLogInLogo(),

              SizedBox(height: 12.h),
              Text('الوليد', style: AppTextStyle.font26PageTitleBoldKufam()),
              Text(
                'منصة الكيمياء التعليمية',
                style: AppTextStyle.font14TextSecondaryRegularTajawal()
                    .copyWith(
                      color: ColorPalette.cardBackground.withValues(alpha: .6),
                    ),
              ),
              verticalSpace(20.h),

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
                    verticalSpace(24.h),

                    CustomTextFormField(
                      labelText: 'البريد الإلكتروني',
                      hintText: 'example@email.com',
                      controller: _emailController,
                      validator: AppValidator.email,
                    ),
                    verticalSpace(16.h),

                    CustomTextFormField(
                      labelText: 'كلمة المرور',
                      hintText: 'أدخل كلمة المرور',
                      controller: _passwordController,
                      obscureText: _isObscure,
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
                    verticalSpace(24.h),

                    CustomButton(text: 'تسجيل الدخول', onPressed: _submit),
                    verticalSpace(16.h),
                    CustomSecondaryButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '.نسيت كلمة المرور؟ تواصل مع المدرس',
                            style:
                                AppTextStyle.font12TextSecondaryRegularTajawal(),
                          ),
                          horizontalSpace(9.w),

                          CircleAvatar(
                            radius: 10.r,
                            backgroundColor: ColorPalette.accent,
                            child: Text(
                              '؟',
                              style:
                                  AppTextStyle.font14TextPrimaryMediumKufam(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(50.h),
            ],
          ),
        ),
      ),
    );
  }
}
