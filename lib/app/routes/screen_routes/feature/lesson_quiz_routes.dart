import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_screen.dart';
import 'package:flutter/material.dart';

abstract final class LessonQuizRoutes {
  const LessonQuizRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.lessonQuiz:
        final lessonId = settings.arguments;

        if (lessonId is! String || lessonId.trim().isEmpty) {
          return _buildInvalidArgumentsRoute(settings);
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) {
            return LessonQuizScreen(
              lessonId: lessonId.trim(),
            );
          },
        );

      default:
        return null;
    }
  }

  static Route<dynamic> _buildInvalidArgumentsRoute(
    RouteSettings settings,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text(
              'تعذر فتح اختبار الدرس.',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      },
    );
  }
}