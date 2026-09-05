import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNoteCard extends StatelessWidget {
  const StudyNoteCard({
    super.key,
    required this.title,
    required this.subject,
    required this.onTap,
    this.accentColor,
  });

  final String title;
  final String subject;
  final VoidCallback onTap;
  final Color? accentColor;

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
                Container(
                  width: 5.w,
                  color: accentColor ?? ColorPalette.highlight,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                        ),
                        verticalSpace(6),
                        Text(
                          subject,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                        ),
                        verticalSpace(20),
                        Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [_ViewButton(), _PdfBadge()],
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

class _ViewButton extends StatelessWidget {
  const _ViewButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        'عرض',
        style: AppTextStyle.font15TextLightBoldTajawal().copyWith(
          color: ColorPalette.primary,
        ),
      ),
    );
  }
}

class _PdfBadge extends StatelessWidget {
  const _PdfBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(CupertinoIcons.doc_text, color: ColorPalette.textRed, size: 30.sp),
        verticalSpace(3),
        Text(
          'PDF ملف',
          style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
            color: ColorPalette.textSecondary,
          ),
        ),
      ],
    );
  }
}
