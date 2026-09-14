import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_state_layout.dart';
import 'package:flutter/material.dart';

class LessonPdfErrorView extends StatelessWidget {
  const LessonPdfErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return LessonPdfStateLayout(
      child: AppErrorState(
        message: errorMessage,
        onRetry: onRetry,
      ),
    );
  }
}