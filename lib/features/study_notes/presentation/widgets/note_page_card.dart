import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotePageCard extends StatelessWidget {
  const NotePageCard({
    super.key,
    required this.note,
    required this.pageNumber,
    this.isSecondaryPage = false,
  });

  final StudyNoteEntity note;
  final int pageNumber;
  final bool isSecondaryPage;

  @override
  Widget build(BuildContext context) {
    final cleanHeading = note.readerHeading.replaceAll(':', '').trim();
    final cleanConceptTitle = note.conceptTitle.replaceAll(':', '').trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorPalette.border, width: 1.5.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.05),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorPalette.primarySoftBackground,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                note.chapterLabel,
                style: AppTextStyle.font12TextPrimaryRegularTajawal().copyWith(
                  color: ColorPalette.primary,
                  fontWeight: FontWeightHelper.bold,
                ),
              ),
            ),
          ),
          verticalSpace(12),
          Text(
            cleanHeading,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font20TextPrimarySemiBoldKufam().copyWith(
              color: ColorPalette.textPrimary,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
          verticalSpace(4),
          Text(
            note.readerSubheading,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
              color: ColorPalette.textSecondary,
            ),
          ),
          verticalSpace(14),
          Container(
            height: 2.5.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorPalette.accent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          verticalSpace(18),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: ColorPalette.primarySoftBackground,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    note.equationText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font20TextBlackSemiBoldKufam().copyWith(
                      color: ColorPalette.primary,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),
                ),
                verticalSpace(10),
                Text(
                  note.equationTypeLabel,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font15TextPrimaryMediumTajawal().copyWith(
                    fontWeight: FontWeightHelper.bold,
                    color: ColorPalette.textPrimary,
                  ),
                ),
                verticalSpace(4),
                Text(
                  note.equationDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                    color: ColorPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(20),
          Text(
            cleanConceptTitle,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font16TextPrimarySemiBoldKufam().copyWith(
              color: ColorPalette.primary,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
          verticalSpace(8),
          Text(
            note.conceptDescription,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
              color: ColorPalette.textSecondary,
              height: 1.6,
            ),
          ),
          verticalSpace(18),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.w,
              runSpacing: 8.h,
              children: note.tags.map((tag) => TagChip(label: tag)).toList(),
            ),
          ),
          verticalSpace(24),
          Center(
            child: Text(
              'منصة الوليد التعليمية • $pageNumber',
              textAlign: TextAlign.center,
              style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                color: ColorPalette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
