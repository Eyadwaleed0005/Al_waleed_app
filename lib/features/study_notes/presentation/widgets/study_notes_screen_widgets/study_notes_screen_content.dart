import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesScreenContent extends StatelessWidget {
  const StudyNotesScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              CustomAppBar(
                title: 'المذكرات',
                backgroundColor: Colors.transparent,
                showBackButton: false,
                actions: [
                  Image.asset(
                    AppImage().studyNotes,
                    width: 24.w,
                    height: 24.h,
                  ),
                ],
              ),
              verticalSpace(24),
              Expanded(
                child: StudyNotesListView(
                  onNoteTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.studyNotePdfReaderScreen,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}