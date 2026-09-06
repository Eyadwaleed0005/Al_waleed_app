import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_dialog.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

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
                child: CustomButton(
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
                        Navigator.pop(context);
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
}
