import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ProfileErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: 'حسابي',
                backgroundColor: Colors.transparent,
                showBackButton: false,
                actions: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 28.r,
                    color: ColorPalette.primary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AppErrorState(message: errorMessage, onRetry: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
