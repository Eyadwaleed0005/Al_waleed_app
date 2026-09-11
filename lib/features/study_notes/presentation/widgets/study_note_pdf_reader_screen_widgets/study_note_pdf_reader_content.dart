import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_pdf_reader_screen_widgets/study_note_pdf_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotePdfReaderContent extends StatelessWidget {
  final StudyNoteEntity note;

  const StudyNotePdfReaderContent({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: note.name,
        titleColor: ColorPalette.cardBackground,
        backButtonColor: ColorPalette.cardBackground,
        backgroundColor: ColorPalette.primary,
        showBackButton: true,
        actions: [
          SizedBox(
            width: 56.w,
            child: Center(
              child: ImageIcon(
                AssetImage(AppImage().studyNotes),
                size: 26.r,
                color: ColorPalette.cardBackground,
              ),
            ),
          ),
        ],
      ),
      body: BackgroundStudentLayout(child: StudyNotePdfBody(note: note)),
    );
  }
}
