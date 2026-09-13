import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/presentation/screens/exams_screen.dart';
import 'package:al_waleed/features/exams/presentation/screens/result_exam_screen.dart';
import 'package:al_waleed/features/exams/presentation/screens/start_exam_screen.dart';
import 'package:flutter/material.dart';

abstract final class ExamsRoutes {
  const ExamsRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.examScreen:
        final Object? arguments = settings.arguments;

        if (arguments is! String || arguments.trim().isEmpty) {
          return null;
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) {
            return ExamsScreen(gradeId: arguments.trim());
          },
        );

      case RouteNames.startExamScreen:
        final Object? arguments = settings.arguments;

        if (arguments is! StudentExamSessionEntity) {
          return null;
        }

        return MaterialPageRoute<String?>(
          settings: settings,
          builder: (_) {
            return StartExamScreen(session: arguments);
          },
        );

      case RouteNames.resultExamScreen:
        final Object? arguments = settings.arguments;

        if (arguments is! StudentExamResultEntity) {
          return null;
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) {
            return ResultExamScreen(result: arguments);
          },
        );

      default:
        return null;
    }
  }
}
