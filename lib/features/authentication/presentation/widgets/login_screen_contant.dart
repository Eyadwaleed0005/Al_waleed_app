import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/authentication/presentation/widgets/login_background.dart';
import 'package:al_waleed/features/authentication/presentation/widgets/login_form.dart';
import 'package:al_waleed/features/authentication/presentation/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenContant extends StatelessWidget {
  const LoginScreenContant({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: LoginBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              verticalSpace(40),
              const CustomLogInLogo(),
              verticalSpace(12),
              AppAnimations.primaryTitle(
                child: Text(
                  'الوليد',
                  style: AppTextStyle.font26PageTitleBoldKufam(),
                ),
              ),
              verticalSpace(6),
              AppAnimations.secondaryTitle(
                child: Text(
                  'منصة الكيمياء التعليمية',
                  style:
                      AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
                        color: ColorPalette.cardBackground.withValues(
                          alpha: .6,
                        ),
                      ),
                ),
              ),
              verticalSpace(20),
              AppAnimations.screenSection(
                delay: 900,
                child: CustomAppCard(
                  child: Column(
                    children: [
                      Text(
                        'أهلاً بك من جديد',
                        style: AppTextStyle.font20TextBlackSemiBoldKufam(),
                      ),
                      verticalSpace(8),
                      Text(
                        '.سجّل دخولك للوصول إلى دروسك واختباراتك',
                        style:
                            AppTextStyle.font14TextSecondaryRegularTajawal(),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(24),
                      const LoginForm(),
                    ],
                  ),
                ),
              ),
              verticalSpace(50),
            ],
          ),
        ),
      ),
    );
  }
}