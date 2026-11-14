import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:al_waleed/features/profile/presentation/cubit/personal_info_cubit/personal_info_cubit.dart';
import 'package:al_waleed/features/profile/presentation/validation/update_validator.dart';
import 'package:al_waleed/features/profile/presentation/widgets/personal_info_widgets/confirm_current_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({super.key, required this.state});

  final PersonalInfoState state;

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  bool _isPreparingSave = false;

  bool get _isBusy => _isPreparingSave || widget.state.isSaving;

  bool get _hasChanges {
    final original = widget.state.personalInfo;

    if (original == null) return false;

    return _nameController.text.trim() != original.name.trim() ||
        _phoneController.text.trim() != original.phoneNumber.trim() ||
        _emailController.text.trim().toLowerCase() !=
            original.email.trim().toLowerCase();
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.state.name);

    _phoneController = TextEditingController(text: widget.state.phoneNumber);

    _emailController = TextEditingController(text: widget.state.email);
  }

  @override
  void didUpdateWidget(covariant PersonalInfoForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state.personalInfo != widget.state.personalInfo) {
      _nameController.text = widget.state.name;
      _phoneController.text = widget.state.phoneNumber;
      _emailController.text = widget.state.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _onFieldChanged(String value) {
    setState(() {});
  }

  Future<void> _save() async {
    if (_isBusy || !_hasChanges) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final original = widget.state.personalInfo;

    if (original == null) return;

    FocusScope.of(context).unfocus();

    final name = _nameController.text;
    final phoneNumber = _phoneController.text;
    final email = _emailController.text;

    final hasEmailChanged =
        email.trim().toLowerCase() != original.email.trim().toLowerCase();

    final cubit = context.read<PersonalInfoCubit>();

    setState(() {
      _isPreparingSave = true;
    });

    try {
      String? currentPassword;

      if (hasEmailChanged) {
        currentPassword = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const ConfirmCurrentPasswordDialog(),
        );

        if (!mounted || currentPassword == null) return;
      }

      if (!mounted || cubit.isClosed) return;

      cubit.nameChanged(name);
      cubit.phoneNumberChanged(phoneNumber);
      cubit.emailChanged(email);

      await cubit.save(currentPassword: currentPassword);
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingSave = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = widget.state.isSaving;
    final canSave = _hasChanges && !_isBusy;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AbsorbPointer(
            absorbing: _isBusy,
            child: CustomAppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'معلومات الحساب',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
                  ),
                  verticalSpace(24),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'الاسم',
                    hintText: 'أدخل اسمك',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    readOnly: _isBusy,
                    validator: UpdateValidator.name,
                    onChanged: _onFieldChanged,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: ColorPalette.primary,
                    ),
                  ),
                  verticalSpace(20),
                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: 'رقم الهاتف',
                    hintText: 'أدخل رقم هاتفك',
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.next,
                    readOnly: _isBusy,
                    validator: UpdateValidator.phoneNumber,
                    onChanged: _onFieldChanged,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: ColorPalette.primary,
                    ),
                  ),
                  verticalSpace(20),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: 'البريد الإلكتروني',
                    hintText: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.done,
                    readOnly: _isBusy,
                    validator: UpdateValidator.email,
                    onChanged: _onFieldChanged,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: ColorPalette.primary,
                    ),
                  ),
                  verticalSpace(16),
                  _buildEmailNotice(),
                ],
              ),
            ),
          ),
          verticalSpace(24),
          IgnorePointer(
            ignoring: !canSave,
            child: CustomButton(
              text: 'تعديل',
              isLoading: isSaving,
              background: canSave || isSaving
                  ? ColorPalette.primary
                  : ColorPalette.disabled,
              foreground: canSave || isSaving
                  ? ColorPalette.textLight
                  : ColorPalette.textSecondary,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailNotice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.sp,
            color: ColorPalette.primary,
          ),
          horizontalSpace(8),
          Expanded(
            child: Text(
              'لتغيير البريد الإلكتروني، ستحتاج إلى تأكيد كلمة المرور الحالية. '
              'بعد نجاح الحفظ، استخدم البريد الجديد لتسجيل الدخول.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
