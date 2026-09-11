import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_states/lessons_loading_skeleton.dart';
import 'package:flutter/material.dart';

class LessonsLoadingView extends StatelessWidget {
  const LessonsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsLoadingSkeleton();
  }
}