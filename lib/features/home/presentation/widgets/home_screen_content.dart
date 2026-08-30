import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/home/presentation/widgets/home_category_tab.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              CustomAppBar(
                title: 'الرئيسية',
                backgroundColor: Colors.transparent,
                showBackButton: false,
                actions: [
                  Image.asset(AppImage().homeIcon, height: 24.h, width: 24.w),
                ],
              ),
              verticalSpace(50),
              AspectRatio(
                aspectRatio: 350 / 180,
                child: CustomAppCard(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    alignment: Alignment.topCenter,
                    AppImage().teacherBanner,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              verticalSpace(35),
              AspectRatio(
                aspectRatio: 350 / 180,
                child: CustomAppCard(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    alignment: Alignment.topCenter,
                    AppImage().teacherBanner,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              verticalSpace(20),
              Text(
                'روابط سريعة',
                style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
              ),
              verticalSpace(10),
              Row(
                children: [
                  CustomCategoryCard(
                    label: 'الاختبارات',
                    image: AppImage().exam,
                  ),
                  horizontalSpace(10),
                  CustomCategoryCard(
                    label: 'المذاكرات',
                    image: AppImage().studyNotes,
                  ),
                  horizontalSpace(10),
                  CustomCategoryCard(
                    label: 'الدروس',
                    image: AppImage().bookOpen,
                    onTap: () {
                      context.read<BottomNavigationCubit>().changeIndex(3);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
