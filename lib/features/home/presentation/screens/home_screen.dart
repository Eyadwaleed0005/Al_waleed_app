import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/home/presentation/widgets/home_category_tab.dart';
import 'package:flutter/material.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundStudentLayout(
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
                SizedBox(height: 50.h),
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
                SizedBox(height: 35.h),
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
                SizedBox(height: 20.h),
                Text(
                  'روابط سريعة',
                  style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    CustomCategoryCard(
                      label: 'الاختبارات',
                      image: AppImage().exam,
                    ),

                    SizedBox(width: 10.w),
                    CustomCategoryCard(
                      label: 'المذاكرات',
                      image: AppImage().studyNotes,
                    ),
                    SizedBox(width: 10.w),
                    CustomCategoryCard(
                      label: 'الدروس',
                      image: AppImage().bookOpen,
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteNames.lessons);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
