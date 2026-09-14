import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:flutter/material.dart';

class LessonQuizErrorView extends StatelessWidget {
  const LessonQuizErrorView({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      message: errorMessage,
      onRetry: onRetry,
    );
  }
}