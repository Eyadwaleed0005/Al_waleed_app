import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/notes_header.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewNotesScreen extends StatelessWidget {
  const ViewNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: BackgroundStudentLayout(
        child: Column(
          children: [
            const NotesHeader(title: 'المذكرة'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: StudyNotesList(
                  onNoteTap: () {
                    Navigator.of(context).pushNamed(RouteNames.noteReader);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
