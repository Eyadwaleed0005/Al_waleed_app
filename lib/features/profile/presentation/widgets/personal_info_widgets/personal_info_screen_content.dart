import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/profile/presentation/cubit/personal_info_cubit/personal_info_cubit.dart';
import 'package:al_waleed/features/profile/presentation/widgets/personal_info_widgets/personal_info_form.dart';
import 'package:al_waleed/features/profile/presentation/widgets/personal_info_widgets/personal_info_loading_skeleton.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoScreenContent extends StatelessWidget {
  const PersonalInfoScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonalInfoCubit, PersonalInfoState>(
      listenWhen: (previous, current) {
        return previous.status != current.status &&
            (current.status == PersonalInfoStatus.saveFailure ||
                current.status == PersonalInfoStatus.saved);
      },
      listener: (context, state) {
        if (state.status == PersonalInfoStatus.saveFailure) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.failure,
                title: 'تعذر تعديل البيانات',
                message: state.error!.message,
                actionText: 'حسنًا',
              );
            },
          );
        } else if (state.status == PersonalInfoStatus.saved) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return const CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم حفظ البيانات',
                message: 'تم تحديث بياناتك الشخصية بنجاح.',
                actionText: 'حسنًا',
              );
            },
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !state.isSaving,
          child: ProfileBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AbsorbPointer(
                      absorbing: state.isSaving,
                      child: CustomAppBar(
                        title: 'البيانات الشخصية',
                        showBackButton: true,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    verticalSpace(28),
                    _buildHeader(),
                    verticalSpace(24),
                    _buildBody(context, state),
                    verticalSpace(32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PersonalInfoState state) {
    if (state.status == PersonalInfoStatus.initial ||
        state.status == PersonalInfoStatus.loading) {
      return const PersonalInfoLoadingSkeleton();
    }

    if (state.status == PersonalInfoStatus.loadFailure) {
      return AppErrorState(
        message: state.error!.message,
        onRetry: () {
          context.read<PersonalInfoCubit>().retry();
        },
      );
    }

    final personalInfo = state.personalInfo;

    if (personalInfo == null) {
      return const SizedBox.shrink();
    }

    return PersonalInfoForm(
      key: ValueKey(personalInfo.studentId),
      state: state,
    );
  }

  Widget _buildHeader() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 54.w,
          height: 54.h,
          decoration: BoxDecoration(
            color: ColorPalette.paleSage,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.manage_accounts_outlined,
            size: 30.sp,
            color: ColorPalette.primary,
          ),
        ),
        horizontalSpace(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'بياناتك الشخصية',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
              ),
              verticalSpace(6),
              Text(
                'راجع معلومات حسابك وحدّثها بسهولة.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: AppTextStyle.font14TextSecondaryRegularTajawal(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
