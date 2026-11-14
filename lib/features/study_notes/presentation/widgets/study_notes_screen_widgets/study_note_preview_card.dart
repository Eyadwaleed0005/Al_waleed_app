import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/app_date_time_formatter.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudyNotePreviewCard extends StatelessWidget {
  const StudyNotePreviewCard({
    super.key,
    required this.note,
    required this.onTap,
    this.hasValidSubscription,
    this.isYellowAccent = true,
  });

  final StudyNoteEntity note;
  final VoidCallback onTap;
  final bool? hasValidSubscription;
  final bool isYellowAccent;

  Color get _accentColor {
    return isYellowAccent ? ColorPalette.highlight : ColorPalette.softSage;
  }

  bool get _isLocked {
    return !note.isFree && hasValidSubscription == false;
  }

  String get _accessLabel {
    if (note.isFree) return 'مجانية';
    if (hasValidSubscription == true) return 'متاحة باشتراكك';

    return 'باشتراك';
  }

  IconData get _accessIcon {
    if (note.isFree) return Icons.redeem_outlined;
    if (hasValidSubscription == true) {
      return Icons.verified_outlined;
    }

    return Icons.lock_outline_rounded;
  }

  String get _fileDescription {
    final updatedAt = note.updatedAt;

    if (updatedAt == null) return 'ملف PDF';

    final date = AppDateTimeFormatter.formatDate(updatedAt.toLocal());

    return 'ملف PDF · محدث في $date';
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: ColorPalette.primary,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_buildPreview(), _buildContent()],
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 5.w,
                child: ColoredBox(color: _accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Ink(
      height: 180.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isYellowAccent
              ? const [ColorPalette.lightYellow, ColorPalette.paleMint]
              : const [ColorPalette.softSage, ColorPalette.paleMint],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: SvgPicture.asset(AppImage().bookOpenBig, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 23.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            note.name,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.font16TextPrimarySemiBoldKufam().copyWith(
              color: ColorPalette.textLight,
              height: 1.6,
            ),
          ),
          if (note.description.trim().isNotEmpty) ...[
            verticalSpace(8),
            Text(
              note.description.trim(),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
                color: ColorPalette.paleSage,
                height: 1.6,
              ),
            ),
          ],
          verticalSpace(10),
          Text(
            _fileDescription,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
              color: ColorPalette.softSage,
            ),
          ),
          verticalSpace(18),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(_accessIcon, color: _accentColor, size: 18.sp),
              horizontalSpace(6),
              Expanded(
                child: Text(
                  _accessLabel,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.font12TextSecondaryRegularTajawal()
                      .copyWith(
                        color: ColorPalette.textLight,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: _isLocked ? ColorPalette.highlight : ColorPalette.paleSage,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                _isLocked ? 'تفعيل الاشتراك' : 'عرض المذكرة',
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font15TextPrimaryBoldTajawal(),
              ),
              horizontalSpace(5),
              Icon(
                _isLocked
                    ? Icons.lock_outline_rounded
                    : Icons.chevron_left_rounded,
                color: ColorPalette.primary,
                size: 19.sp,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
