import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/features/authentication/presentation/screens/login_screen.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_details_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_pdf_reader_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:al_waleed/features/profile/presentation/screens/profile_screen.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/study_note_pdf_reader_screen.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/study_notes_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainNavigationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainNavigationScreen(),
        );

      case RouteNames.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case RouteNames.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      case RouteNames.profileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      case RouteNames.lessons:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LessonsScreen(),
        );

      case RouteNames.lessonDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LessonDetailsScreen(),
        );

      case RouteNames.lessonDetailsPdf:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LessonPdfReaderScreen(),
        );

      case RouteNames.studyNotesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StudyNotesScreen(),
        );

      case RouteNames.liveSessionScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LiveSessionScreen(),
        );

      case RouteNames.studyNotePdfReaderScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StudyNotePdfReaderScreen(),
        );

      case RouteNames.lessonQuiz:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LessonQuizScreen(),
        );

      default:
        return null;
    }
  }
}
