import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/blurred_oval_shadow.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/splash_loading_bar.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/splash_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashLoadingView extends StatelessWidget {
  const SplashLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAnimations.logoEntrance(
                      child: AppAnimations.logoFloating(
                        child: Image.asset(
                          AppImage().alwaleedImg,
                          width: 280.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    AppAnimations.shadowEntrance(
                      child: AppAnimations.shadowPulse(
                        child: const BlurredOvalShadow(translateY: -35),
                      ),
                    ),
                    verticalSpace(18),
                    AppAnimations.primaryTitle(
                      child: SplashTitleText(
                        text: 'منصة الوليد للكيمياء',
                        style: AppTextStyle.font19TextLightSemiBoldKufam()
                            .copyWith(
                              color: ColorPalette.highlight,
                              fontSize: 20.sp,
                            ),
                      ),
                    ),
                    verticalSpace(35),
                    AppAnimations.secondaryTitle(
                      child: SplashTitleText(
                        text: 'كيمياء بوضوح... من أول ذرة',
                        style: AppTextStyle.font14TextSecondaryRegularTajawal()
                            .copyWith(color: ColorPalette.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppAnimationsLoadingBar(),
            verticalSpace(16),
            AppAnimations.loadingText(
              child: SplashTitleText(
                text: 'جاري تجهيز حسابك',
                style: AppTextStyle.font14TextSecondaryRegularTajawal()
                    .copyWith(color: ColorPalette.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppAnimationsLoadingBar extends StatelessWidget {
  const AppAnimationsLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAnimations.loadingBar(child: const SplashLoadingBar());
  }
}
