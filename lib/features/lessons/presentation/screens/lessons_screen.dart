import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              CustomAppBar(
                title: 'الدروس',
                actions: [
                  Image.asset(
                    AppImage().bookOpenBig,
                    height: 29.h,
                    width: 29.w,
                  ),
                ],
                showBackButton: true,
                backgroundColor: Colors.transparent,
              ),
              Text(
                'اختر المنهج',
                style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
