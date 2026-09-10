import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_note_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesListView extends StatelessWidget {
  const StudyNotesListView({
    super.key,
    required this.notes,
    required this.onNoteTap,
  });

  final List<StudyNoteEntity> notes;
  final ValueChanged<StudyNoteEntity> onNoteTap;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return  AppEmptyState(
        iconBackgroundColor:  ColorPalette.textMuted.withValues(alpha: 0.45),
        iconContainerSize: 140,
        iconSize: 60,
        title: 'لا توجد مذكرات متاحة حاليًا',
        iconWidget:Image.asset(AppImage().emptyNotesIcon, ),
      );
    }

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
          child: StudyNotePreviewCard(
            note: note,
            onTap: () => onNoteTap(note),
          ),
        );
      },
    );
  }
}
