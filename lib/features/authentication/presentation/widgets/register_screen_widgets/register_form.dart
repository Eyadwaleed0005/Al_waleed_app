import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/validation/register_validation.dart';
import 'package:al_waleed/features/authentication/presentation/widgets/register_screen_widgets/already_have_account_text.dart';
import 'package:al_waleed/features/authentication/presentation/widgets/register_screen_widgets/register_grade_dialog.dart';
import 'package:al_waleed/features/grades/domain/entities/grade_entity.dart';
import 'package:al_waleed/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.onRegistered});

  final VoidCallback onRegistered;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  GradeEntity? _selectedGrade;

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _selectGrade() async {
    FocusScope.of(context).unfocus();

    final gradesStream = getIt<StreamGradesUseCase>()(activeOnly: true);

    final grade = await showDialog<GradeEntity>(
      context: context,
      builder: (dialogContext) {
        return RegisterGradeDialog(
          gradesStream: gradesStream,
          selectedGradeId: _selectedGrade?.gradeId,
        );
      },
    );

    if (!mounted || grade == null) return;

    setState(() {
      _selectedGrade = grade;
      _gradeController.text = grade.name;
    });
  }

  void _submit() {
    final cubit = context.read<RegisterCubit>();

    if (cubit.state is RegisterLoading || cubit.state is RegisterSuccess) {
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final grade = _selectedGrade;

    if (grade == null) return;

    FocusScope.of(context).unfocus();

    cubit.register(
      name: _nameController.text.trim(),
      gradeId: grade.gradeId,
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: CustomOperationResultDialog(
            type: CustomOperationResultType.success,
            title: 'تم إنشاء حسابك بنجاح',
            message: 'حسابك جاهز، والاشتراك لم يتم تفعيله بعد.',
            actionText: 'متابعة',
            onActionPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );

    if (!mounted) return;

    widget.onRegistered();
  }

  void _openLogin() {
    FocusScope.of(context).unfocus();

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
  }

  Widget _passwordVisibilityButton({
    required bool isObscure,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: ColorPalette.textMuted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.failure,
                title: 'تعذر إنشاء الحساب',
                message: state.errorMessage,
                actionText: 'حاول مرة أخرى',
              );
            },
          );
        } else if (state is RegisterSuccess) {
          _showSuccessDialog();
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        final isBlocked = isLoading || state is RegisterSuccess;

        return AbsorbPointer(
          absorbing: isBlocked,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'اسم الطالب',
                  hintText: 'أدخل اسمك',
                  validator: RegisterValidation.name,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  readOnly: isBlocked,
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _gradeController,
                  labelText: 'الصف الدراسي',
                  hintText: 'اختر الصف الدراسي',
                  readOnly: true,
                  onTap: _selectGrade,
                  validator: (_) {
                    if (_selectedGrade == null) {
                      return 'اختر الصف الدراسي';
                    }

                    return null;
                  },
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ColorPalette.textMuted,
                  ),
                  onSuffixTap: _selectGrade,
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@email.com',
                  validator: RegisterValidation.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  readOnly: isBlocked,
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  hintText: 'أدخل رقم هاتفك',
                  validator: RegisterValidation.phoneNumber,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  readOnly: isBlocked,
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  hintText: 'أدخل كلمة المرور',
                  validator: RegisterValidation.password,
                  obscureText: _isPasswordObscure,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  readOnly: isBlocked,
                  prefixIcon: _passwordVisibilityButton(
                    isObscure: _isPasswordObscure,
                    onPressed: () {
                      setState(() {
                        _isPasswordObscure = !_isPasswordObscure;
                      });
                    },
                  ),
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  hintText: 'أعد إدخال كلمة المرور',
                  validator: (value) {
                    return RegisterValidation.confirmPassword(
                      value,
                      _passwordController.text,
                    );
                  },
                  obscureText: _isConfirmPasswordObscure,
                  textInputAction: TextInputAction.done,
                  textDirection: TextDirection.ltr,
                  readOnly: isBlocked,
                  onSubmitted: (_) => _submit(),
                  prefixIcon: _passwordVisibilityButton(
                    isObscure: _isConfirmPasswordObscure,
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                      });
                    },
                  ),
                ),
                verticalSpace(24),
                CustomButton(
                  text: 'إنشاء حساب',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
                verticalSpace(16),
                AlreadyHaveAccountText(
                  isLoading: isBlocked,
                  onPressed: _openLogin,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
