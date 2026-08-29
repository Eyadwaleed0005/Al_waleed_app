import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/empty_lessons_content.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lessons_category_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsScreenContent extends StatelessWidget {
  final bool isEmpty;
  const LessonsScreenContent({super.key, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CustomAppBar(
                title: 'الدروس',
                showBackButton: true,
                backgroundColor: Colors.transparent,
                actions: [
                  Image.asset(
                    AppImage().bookOpenBig,
                    width: 28.w,
                    height: 28.h,
                  ),
                ],
              ),
              isEmpty
                  ? Expanded(child: const EmptyLessonsContent())
                  : const LessonsCategoryContent(),
            ],
          ),
        ),
      ),
    );
  }
}
