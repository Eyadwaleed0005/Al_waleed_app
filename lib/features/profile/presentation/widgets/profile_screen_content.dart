import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_dialog.dart';
import 'package:al_waleed/features/profile/cubit/logout_cubit.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listenWhen: (previous, current) => current != previous,
      listener: (context, state) {
        if (state is LogoutSuccess) {
          showAppToast(
            context,
            message: 'تم تسجيل الخروج بنجاح',
            icon: Icons.check_circle_rounded,
          );
          Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
        } else if (state is LogoutFailure) {
          showAppToast(
            context,
            message: 'فشل تسجيل الخروج',
            icon: Icons.error_outline_rounded,
          );
        }
      },
      child: ProfileBackground(
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
                        'محمد جلال عبد الفتاح',
                        style: AppTextStyle.font20TextBlackSemiBoldKufam(),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(6),
                      Text(
                        'طالب الصف الثالث الثانوي',
                        style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                verticalSpace(32),
                AppAnimations.screenSection(
                  delay: 450,
                  child: const ProfileInfoCard(),
                ),
                verticalSpace(32),
                AppAnimations.screenSection(
                  delay: 650,
                  child: BlocSelector<LogoutCubit, LogoutState, bool>(
                    selector: (state) => state is LogoutLoading,
                    builder: (context, isLoading) {
                      return CustomButton(
                        isLoading: isLoading,
                        text: 'تسجيل الخروج',
                        foreground: ColorPalette.error,
                        borderColor: ColorPalette.error.withValues(alpha: .3),
                        background: ColorPalette.cardBackground,
                        onPressed: () {
                          CustomDialog.showDelete(
                            context,
                            icon: Icons.logout_outlined,
                            iconBorderRadius: BorderRadius.circular(16.r),
                            title: 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
                            message:
                                'ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى حسابك.',
                            primaryText: 'تسجيل الخروج',
                            secondaryText: 'إلغاء',
                            onDelete: () {
                              context.read<LogoutCubit>().logout();
                            },
                          );
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
      ),
    );
  }
}
