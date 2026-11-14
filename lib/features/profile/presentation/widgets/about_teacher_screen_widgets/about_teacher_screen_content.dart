import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/profile/presentation/widgets/about_teacher_screen_widgets/about_teacher_header.dart';
import 'package:al_waleed/features/profile/presentation/widgets/about_teacher_screen_widgets/about_teacher_section.dart';
import 'package:al_waleed/features/profile/presentation/widgets/about_teacher_screen_widgets/teacher_biography.dart';
import 'package:al_waleed/features/profile/presentation/widgets/about_teacher_screen_widgets/teacher_social_links.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutTeacherScreenContent extends StatelessWidget {
  const AboutTeacherScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomAppBar(
                title: 'عن المعلّم',
                showBackButton: true,
                backgroundColor: Colors.transparent,
              ),
              verticalSpace(24),
              const AboutTeacherHeader(),
              verticalSpace(24),
              const AboutTeacherSection(
                title: 'خبرة تصنع الفارق',
                child: TeacherBiography(),
              ),
              verticalSpace(16),
              const AboutTeacherSection(
                title: 'تواصل مع المعلّم',
                child: TeacherSocialLinks(),
              ),
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
