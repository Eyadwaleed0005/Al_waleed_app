import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_actions_list.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSuccessView extends StatelessWidget {
  const ProfileSuccessView({
    super.key,
    required this.profile,
    required this.imageAsset,
  });

  final ProfileEntity profile;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              AppAnimations.screenSection(
                delay: 100,
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
              verticalSpace(24),
              AppAnimations.screenSection(
                delay: 250,
                child: ProfileHeaderCard(
                  name: profile.studentProfile.name,
                  email: profile.studentProfile.email,
                  imageAsset: imageAsset,
                ),
              ),
              verticalSpace(24),
              AppAnimations.screenSection(
                delay: 450,
                child: BlocSelector<LogoutCubit, LogoutState, bool>(
                  selector: (state) => state is LogoutLoading,
                  builder: (context, isLoading) {
                    return AbsorbPointer(
                      absorbing: isLoading,
                      child: ProfileActionsList(
                        gradeName: profile.grade.name,
                        onPersonalInfo: () {},
                        onSubscription: () {},
                        onAboutTeacher: () {},
                        onLogout: () {
                          if (isLoading) return;

                          _showLogoutDialog(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final cubit = context.read<LogoutCubit>();

    if (cubit.state is LogoutLoading) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final dialogRoute = ModalRoute.of(dialogContext)!;
        final navigator = Navigator.of(dialogContext);

        return BlocConsumer<LogoutCubit, LogoutState>(
          bloc: cubit,
          listenWhen: (previous, current) {
            return current is LogoutFailure;
          },
          listener: (context, state) {
            if (dialogRoute.isActive) {
              navigator.removeRoute(dialogRoute);
            }
          },
          builder: (context, state) {
            final isLoading = state is LogoutLoading;

            return PopScope(
              canPop: !isLoading,
              child: AbsorbPointer(
                absorbing: isLoading,
                child: CustomOperationResultDialog(
                  type: CustomOperationResultType.failure,
                  failureIcon: Icons.logout_outlined,
                  title: 'تسجيل الخروج',
                  message: 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
                  actionText: 'تسجيل الخروج',
                  secondaryActionText: 'إلغاء',
                  isLoading: isLoading,
                  onActionPressed: () {
                    if (cubit.state is LogoutLoading) return;

                    cubit.logout();
                  },
                  onSecondaryActionPressed: () {
                    navigator.pop();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
