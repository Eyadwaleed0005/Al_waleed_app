import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_document_preview.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_page_progress.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_Reader_controls.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/reader_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteReaderScreen extends StatelessWidget {
  const NoteReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        body: BackgroundStudentLayout(
          child: SafeArea(
            child: Column(
              children: [
                const ReaderHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const LessonPageProgress(),
                ),
                verticalSpace(18),
                const Expanded(child: LessonDocumentPreview()),
                verticalSpace(16),
                const LessonReaderControls(),
                verticalSpace(16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
