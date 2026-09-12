import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          child: Column(
            children: [
              CustomAppBar(
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
              verticalSpace(50),
              const ProfileLoadingSkeleton(),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}