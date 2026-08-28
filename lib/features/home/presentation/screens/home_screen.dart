import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/widgets/custom_header_bar.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                CustomHeaderBar(
                  title: 'الرئيسية',
                  iconPath: AppImage().homeIcon,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
