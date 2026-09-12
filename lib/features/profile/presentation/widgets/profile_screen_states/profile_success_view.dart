import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_dialog.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSuccessView extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileSuccessView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final studentProfile = profile.studentProfile;

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
              verticalSpace(50),
              AppAnimations.screenSection(
                delay: 250,
                child: Column(
                  children: [
                    Text(
                      studentProfile.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font20TextBlackSemiBoldKufam(),
                    ),
                    verticalSpace(6),
                    Text(
                      'طالب ${profile.grade.name}',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                    ),
                  ],
                ),
              ),
              verticalSpace(32),
              AppAnimations.screenSection(
                delay: 450,
                child: ProfileInfoCard(profile: profile),
              ),
              verticalSpace(32),
              AppAnimations.screenSection(
                delay: 650,
                child: BlocSelector<LogoutCubit, LogoutState, bool>(
                  selector: (state) {
                    return state is LogoutLoading;
                  },
                  builder: (context, isLoading) {
                    return CustomButton(
                      isLoading: isLoading,
                      text: 'تسجيل الخروج',
                      foreground: ColorPalette.error,
                      borderColor: ColorPalette.error.withValues(alpha: 0.30),
                      background: ColorPalette.cardBackground,
                      onPressed: () {
                        if (isLoading) return;
                        _showLogoutDialog(context);
                      },
                    );
                  },
                ),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    CustomDialog.showDelete(
      context,
      icon: Icons.logout_outlined,
      iconBorderRadius: BorderRadius.circular(16.r),
      title: 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
      message: 'ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى حسابك.',
      primaryText: 'تسجيل الخروج',
      secondaryText: 'إلغاء',
      onDelete: () {
        context.read<LogoutCubit>().logout();
      },
    );
  }
}
