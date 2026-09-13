


import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_screen.dart';
import 'package:flutter/material.dart';

abstract final class LessonQuizRoutes {
  const LessonQuizRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.lessonQuiz:
        final lessonId = settings.arguments as String;

        
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LessonQuizScreen(lessonId: lessonId),
        );

      default:
        return null;
    }
  }
}