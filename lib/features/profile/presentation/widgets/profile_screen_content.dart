import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:al_waleed/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_screen_states/profile_error_view.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_screen_states/profile_loading_view.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_screen_states/profile_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listenWhen: (previous, current) {
        return current is LogoutSuccess || current is LogoutFailure;
      },
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);

          return;
        }

        if (state is LogoutFailure) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.failure,
                title: 'تعذر تسجيل الخروج',
                message: state.error.message,
                actionText: 'إعادة المحاولة',
                secondaryActionText: 'إلغاء',
                failureIcon: Icons.logout_rounded,
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<LogoutCubit>().logout();
                },
                onSecondaryActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileFailure) {
            return ProfileErrorView(
              errorMessage: state.error.message,
              onRetry: context.read<ProfileCubit>().retry,
            );
          }

          if (state is ProfileSuccess) {
            return ProfileSuccessView(profile: state.profile);
          }

          return const ProfileLoadingView();
        },
      ),
    );
  }
}
