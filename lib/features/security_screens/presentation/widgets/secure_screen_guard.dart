import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_cubit.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecureScreenGuard extends StatelessWidget {
  final Widget child;

  const SecureScreenGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecureScreenCubit, SecureScreenState>(
      builder: (context, state) {
        if (state is SecureScreenEnabled) {
          return child;
        }

        if (state is SecureScreenFailure) {
          return Material(
            color: ColorPalette.background,
            child: SafeArea(
              child: AppErrorState(
                message: state.error.message,
                onRetry: context.read<SecureScreenCubit>().retry,
              ),
            ),
          );
        }

        return const Material(
          color: ColorPalette.background,
          child: Center(
            child: AppLoadingIndicator(
              color: ColorPalette.primary,
              size: 32,
              strokeWidth: 3,
            ),
          ),
        );
      },
    );
  }
}
