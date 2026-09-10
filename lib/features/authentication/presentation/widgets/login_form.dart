import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/validation/login_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          showDialog(
            context: context,
            builder: (context) => CustomOperationResultDialog(
              type: CustomOperationResultType.failure,
              title: 'خطأ في تسجيل الدخول',
              message: state.errorMessage,
              actionText: 'حاول مرة أخرى',
            ),
          );
        } else if (state is LoginSuccess) {
          showDialog(
            context: context,
            builder: (context) => CustomOperationResultDialog(
              type: CustomOperationResultType.success,
              title: 'تم تسجيل الدخول بنجاح',
              message: 'مرحباً بك مجدداً',
              actionText: 'متابعة',
              onActionPressed: () {
                Navigator.pushNamed(context, RouteNames.mainNavigationScreen);
              },
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'البريد الإلكتروني',
                hintText: 'example@email.com',
                controller: _emailController,
                validator: LoginValidation.email,
                readOnly: isLoading,
              ),
              verticalSpace(16),
              CustomTextFormField(
                labelText: 'كلمة المرور',
                hintText: 'أدخل كلمة المرور',
                controller: _passwordController,
                obscureText: _isObscure,
                validator: LoginValidation.password,
                readOnly: isLoading,
                prefixIcon: IconButton(
                  onPressed: isLoading ? null : _togglePasswordVisibility,
                  icon: Icon(
                    _isObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: ColorPalette.textMuted,
                  ),
                ),
              ),
              verticalSpace(24),
              CustomButton(
                text: 'تسجيل الدخول',
                isLoading: isLoading,
                onPressed: () => _submit(context),
              ),
              verticalSpace(16),
              CustomSecondaryButton(
                onPressed: isLoading ? null : () {},
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
      },
    );
  }
}
