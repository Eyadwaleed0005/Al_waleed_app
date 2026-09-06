import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/home/presentation/widgets/home_banners.dart';
import 'package:al_waleed/features/home/presentation/widgets/home_quick_links_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppAnimations.screenSection(
                delay: 100,
                child: CustomAppBar(
                  title: 'الرئيسية',
                  backgroundColor: Colors.transparent,
                  showBackButton: false,
                  actions: [
                    Image.asset(AppImage().homeIcon, height: 24.h, width: 24.w),
                  ],
                ),
              ),
              verticalSpace(50),
              const HomeBanners(),
              verticalSpace(20),
              AppAnimations.screenSection(
                delay: 600,
                child: const HomeQuickLinksSection(),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
