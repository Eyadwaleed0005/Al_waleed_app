import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_details_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lesson_pdf_reader_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
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
      case RouteNames.noteReader:
        final note = settings.arguments as StudyNoteEntity;
        return MaterialPageRoute(
          builder: (context) => NoteReaderScreen(note: note),
        );
      default:
        return null;
    }
  }
}
