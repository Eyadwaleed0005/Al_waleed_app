import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_body.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_header.dart';
import 'package:flutter/material.dart';

class LessonPdfReaderContent extends StatelessWidget {
  const LessonPdfReaderContent({super.key, required this.lesson});

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LessonPdfReaderHeader(lessonTitle: lesson.title),
      body: BackgroundStudentLayout(child: LessonPdfBody(lesson: lesson)),
    );
  }
}
