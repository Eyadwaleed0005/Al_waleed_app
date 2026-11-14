import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_note_preview_card.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_access_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StudyNotesListView extends StatelessWidget {
  const StudyNotesListView({
    super.key,
    required this.notes,
    required this.showFree,
    required this.hasValidSubscription,
    required this.onAccessTypeChanged,
    required this.onNoteTap,
  });

  final List<StudyNoteEntity> notes;
  final bool showFree;
  final bool? hasValidSubscription;
  final ValueChanged<bool> onAccessTypeChanged;
  final ValueChanged<StudyNoteEntity> onNoteTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
      itemCount: notes.isEmpty ? 2 : notes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: StudyNotesAccessFilter(
              showFree: showFree,
              onChanged: onAccessTypeChanged,
            ),
          );
        }

        if (notes.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: AppEmptyState(
              iconBackgroundColor: ColorPalette.textMuted.withValues(
                alpha: 0.45,
              ),
              iconContainerSize: 140,
              iconSize: 60,
              title: showFree
                  ? 'لا توجد مذكرات مجانية حاليًا'
                  : 'لا توجد مذكرات مدفوعة حاليًا',
              subtitle: 'يمكنك الانتقال للقسم الآخر لعرض المذكرات المتاحة.',
              iconWidget: SvgPicture.asset(AppImage().emptyNotesIcon),
            ),
          );
        }

        final noteIndex = index - 1;
        final note = notes[noteIndex];

        return Padding(
          key: ValueKey(note.noteId),
          padding: EdgeInsets.only(
            bottom: noteIndex == notes.length - 1 ? 0 : 14.h,
          ),
          child: AppAnimations.screenSection(
            delay: 60 * (noteIndex < 5 ? noteIndex : 5),
            child: StudyNotePreviewCard(
              note: note,
              hasValidSubscription: hasValidSubscription,
              isYellowAccent: noteIndex.isEven,
              onTap: () => onNoteTap(note),
            ),
          ),
        );
      },
    );
  }
}
