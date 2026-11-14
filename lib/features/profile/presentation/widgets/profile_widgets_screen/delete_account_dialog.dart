import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/core/widgets/custom_text_form_field.dart';
import 'package:al_waleed/features/profile/presentation/cubit/delete_account_cubit/delete_account_cubit.dart';
import 'package:al_waleed/features/profile/presentation/cubit/delete_account_cubit/delete_account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider(
          create: (_) => getIt<DeleteAccountCubit>(),
          child: const DeleteAccountDialog(),
        );
      },
    );
  }

  @override
  State<DeleteAccountDialog> createState() {
    return _DeleteAccountDialogState();
  }
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _deleteAccount() {
    final cubit = context.read<DeleteAccountCubit>();

    if (cubit.state is DeleteAccountLoading ||
        cubit.state is DeleteAccountSuccess) {
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    cubit.deleteAccount(currentPassword: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          _passwordController.clear();

          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteAccountLoading;

        return PopScope(
          canPop: !isLoading,
          child: AbsorbPointer(
            absorbing: isLoading,
            child: CustomOperationResultDialog(
              type: CustomOperationResultType.failure,
              failureIcon: Icons.delete_forever_outlined,
              title: 'حذف الحساب نهائيًا',
              message:
                  'سيؤدي حذف الحساب إلى إزالة بياناتك الشخصية '
                  'وبيانات الاشتراك والنتائج المرتبطة بحسابك.\n\n'
                  'هذا الإجراء نهائي ولا يمكن التراجع عنه.\n'
                  'أدخل كلمة المرور الحالية لتأكيد الحذف.',
              actionText: 'حذف الحساب نهائيًا',
              secondaryActionText: 'إلغاء',
              isLoading: isLoading,
              onActionPressed: _deleteAccount,
              onSecondaryActionPressed: () {
                if (isLoading) return;

                Navigator.of(context).pop();
              },
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: 'كلمة المرور الحالية',
                      hintText: 'أدخل كلمة المرور الحالية',
                      isPassword: true,
                      showPasswordCopyIcon: false,
                      readOnly: isLoading,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك اكتب كلمة المرور الحالية';
                        }

                        return null;
                      },
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: ColorPalette.primary,
                      ),
                    ),
                    if (state is DeleteAccountFailure) ...[
                      verticalSpace(12),
                      Text(
                        state.error.message,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: AppTextStyle.font12TextSecondaryRegularTajawal()
                            .copyWith(color: ColorPalette.error, height: 1.6),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
