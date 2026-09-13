import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/exams_screen_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsScreenLoadingView extends StatelessWidget {
  const ExamsScreenLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: const ExamsScreenLoadingSkeleton(),
    );
  }
}
