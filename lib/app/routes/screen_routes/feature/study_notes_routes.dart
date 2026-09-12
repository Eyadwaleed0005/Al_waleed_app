import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/study_note_pdf_reader_screen.dart';
import 'package:flutter/material.dart';

abstract final class StudyNotesRoutes {
  const StudyNotesRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.studyNotePdfReaderScreen:
        final note = settings.arguments;

        if (note is! StudyNoteEntity) {
          return _buildInvalidArgumentsRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return StudyNotePdfReaderScreen(note: note);
          },
        );

      default:
        return null;
    }
  }

  static MaterialPageRoute<void> _buildInvalidArgumentsRoute(
    RouteSettings settings,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        return const Scaffold(body: Center(child: Text('تعذر فتح المذكرة')));
      },
    );
  }
}
