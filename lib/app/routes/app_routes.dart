import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/features/auth/presentation/screens/login_screen.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_details_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_pdf_reader_screen.dart';
import 'package:al_waleed/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:al_waleed/features/profile/screens/profile_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/note_reader_screen.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/view_notes_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.main:
        return MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        );
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => const LogInScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case RouteNames.lessons:
        return MaterialPageRoute(builder: (context) => const LessonsScreen());
      case RouteNames.lessonDetails:
        return MaterialPageRoute(
          builder: (context) => const LessonDetailsScreen(),
        );
      case RouteNames.lessonDetailsPdf:
        return MaterialPageRoute(
          builder: (context) => const LessonPdfReaderScreen(),
        );
      case RouteNames.studyNotes:
        return MaterialPageRoute(builder: (context) => const ViewNotesScreen());
      case RouteNames.liveSession:
        return MaterialPageRoute(
          builder: (context) => const LiveSessionScreen(),
        );
      case RouteNames.noteReader:
        return MaterialPageRoute(
          builder: (context) => const NoteReaderScreen(),
        );
      case RouteNames.lessonQuiz:
        return MaterialPageRoute(
          builder: (context) => const LessonQuizScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
