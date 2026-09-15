import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/exams_screen_loading_skeleton.dart';
import 'package:flutter/material.dart';

class ExamsScreenLoadingView extends StatelessWidget {
  const ExamsScreenLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      child: ExamsScreenLoadingSkeleton(),
    );
  }
}
