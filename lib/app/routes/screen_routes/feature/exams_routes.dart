import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/exams/presentation/screens/exams_screen.dart';
import 'package:al_waleed/features/exams/presentation/screens/start_exam_screen.dart';
import 'package:al_waleed/features/exams/presentation/screens/result_exam_screen.dart';
import 'package:flutter/material.dart';

abstract class ExamsRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.examScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return ExamsScreen();
          },
        );

      case RouteNames.startExamScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return StartExamScreen();
          },
        );

      case RouteNames.resultExamScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return ResultExamScreen();
          },
        );

      default:
        return null;
    }
  }

  /* static MaterialPageRoute<void> _buildInvalidArgumentsRoute(
    RouteSettings settings,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        return const Scaffold(body: Center(child: Text('تعذر فتح المذكرة')));
      },
    );
  }*/
}
