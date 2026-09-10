import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_note_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesListView extends StatelessWidget {
  final VoidCallback onNoteTap;

  const StudyNotesListView({super.key, required this.onNoteTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
      itemCount: 2,
      separatorBuilder: (_, _) => verticalSpace(14),
      itemBuilder: (context, index) {
        return AppAnimations.screenSection(
          delay: 60 * index,
          child: StudyNotePreviewCard(
            title: index == 0
                ? 'مذكرة الكيمياء العضوية'
                : 'مذكرة الكيمياء الحرارية',
            subtitle: 'الكيمياء • الصف الثالث الثانوي',
            onTap: onNoteTap,
          ),
        );
      },
    );
  }
}
