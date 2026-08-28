import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesList extends StatelessWidget {
  const StudyNotesList({
    super.key,
    required this.notes,
    required this.onNoteTap,
  });

  final List<StudyNoteEntity> notes;
  final ValueChanged<StudyNoteEntity> onNoteTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
      itemCount: notes.length,
      separatorBuilder: (_, _) => verticalSpace(14),
      itemBuilder: (context, index) {
        final note = notes[index];

        return AppAnimations.screenSection(
          delay: 60 * index,
          child: StudyNoteCard(note: note, onTap: () => onNoteTap(note)),
        );
      },
    );
  }
}
