import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_result_screen_widgets/lesson_quiz_result_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessonQuizResultScreen extends StatelessWidget {
  const LessonQuizResultScreen({
    super.key,
    this.score = 3,
    this.totalQuestions = 5,
    this.onReviewAnswers,
    this.onRetryQuiz,
  });

  final int score;
  final int totalQuestions;
  final VoidCallback? onReviewAnswers;
  final VoidCallback? onRetryQuiz;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: Scaffold(
        body: LessonQuizResultScreenContent(
          score: score,
          totalQuestions: totalQuestions,
          onReviewAnswers: onReviewAnswers,
          onRetryQuiz: onRetryQuiz,
        ),
      ),
    );
  }
}
