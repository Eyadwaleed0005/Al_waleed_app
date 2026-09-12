import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_details_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_pdf_reader_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:flutter/material.dart';

abstract final class LessonsRoutes {
  const LessonsRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.lessons:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LessonsScreen(),
        );

      case RouteNames.lessonDetails:
        final lesson = settings.arguments;

        if (lesson is! LessonEntity) {
          return _buildInvalidLessonRoute(
            settings: settings,
            message: 'تعذر فتح الدرس',
          );
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => LessonDetailsScreen(lesson: lesson),
        );

      case RouteNames.lessonDetailsPdf:
        final lesson = settings.arguments;

        if (lesson is! LessonEntity) {
          return _buildInvalidLessonRoute(
            settings: settings,
            message: 'تعذر فتح ملف الدرس',
          );
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => LessonPdfReaderScreen(lesson: lesson),
        );

      default:
        return null;
    }
  }

  static Route<void> _buildInvalidLessonRoute({
    required RouteSettings settings,
    required String message,
  }) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        return Scaffold(body: Center(child: Text(message)));
      },
    );
  }
}
