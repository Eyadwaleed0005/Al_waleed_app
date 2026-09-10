import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_review_screen_widgets/lesson_quiz_review_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessonQuizReviewScreen extends StatelessWidget {
  const LessonQuizReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: const Scaffold(
        body: LessonQuizReviewScreenContent(),
      ),
    );
  }
}
