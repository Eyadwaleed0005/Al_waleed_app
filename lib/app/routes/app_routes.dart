import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/screens/login_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_details_screen.dart';
import 'package:al_waleed/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/study_note_pdf_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainNavigationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainNavigationScreen(),
        );

      case RouteNames.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => getIt.get<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case RouteNames.liveSessionScreen:
        final gradeId = settings.arguments as String;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LiveSessionScreen(gradeId: gradeId),
        );

      case RouteNames.studyNotePdfReaderScreen:
        final note = settings.arguments as StudyNoteEntity?;

        if (note == null) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                const Scaffold(body: Center(child: Text('تعذر فتح المذكرة'))),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => StudyNotePdfReaderScreen(note: note),
        );

      /* case RouteNames.lessonQuiz:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LessonQuizScreen(),
        );*/
      case RouteNames.lessonDetails:
        return MaterialPageRoute(builder: (_) => LessonDetailsScreen());
    case RouteNames.lessonQuiz:
        return MaterialPageRoute(builder: (_) => LessonQuizScreen()); 
      default:
        return null;
    }
  }
}
