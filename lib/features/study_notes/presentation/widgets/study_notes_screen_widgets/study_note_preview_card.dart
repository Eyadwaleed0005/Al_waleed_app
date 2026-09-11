import 'package:al_waleed/core/helper/app_date_time_formatter.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotePreviewCard extends StatelessWidget {
  const StudyNotePreviewCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  final StudyNoteEntity note;
  final VoidCallback onTap;

  String get _formattedUpdatedAt {
    final updatedAt = note.updatedAt;

    if (updatedAt == null) {
      return 'ملف PDF';
    }

    final formattedDate = AppDateTimeFormatter.formatDate(updatedAt);

    return 'ملف PDF · محدث في $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: ColorPalette.primarySoftBackground,
        highlightColor: ColorPalette.primarySoftBackground,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorPalette.surface,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.primary.withValues(alpha: 0.06),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(width: 5.w, color: ColorPalette.highlight),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          note.name,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                        ),
                        verticalSpace(6),
                        Text(
                          note.description.isEmpty
                              ? _formattedUpdatedAt
                              : note.description,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyle.font14TextSecondaryRegularTajawal(),
                        ),
                        verticalSpace(20),
                        Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const _ViewNoteButton(),
                            const _PdfFileBadge(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewNoteButton extends StatelessWidget {
  const _ViewNoteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text('عرض', style: AppTextStyle.font15TextPrimaryBoldTajawal()),
    );
  }
}

class _PdfFileBadge extends StatelessWidget {
  const _PdfFileBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(CupertinoIcons.doc_text, color: ColorPalette.textRed, size: 30.sp),
        verticalSpace(3),
        Text(
          'ملف PDF',
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font12TextSecondaryRegularTajawal(),
        ),
      ],
    );
  }
}
