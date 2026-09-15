import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StudyNotesEmptyView extends StatelessWidget {
  const StudyNotesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        iconBackgroundColor: ColorPalette.textMuted.withValues(alpha: 0.10),
        iconContainerSize: 140,
        iconSize: 60,
        title: 'لا توجد مذكرات متاحة حاليًا',
        subtitle: 'ستظهر مذكرات صفك هنا فور إضافتها من المدرس.',
        iconWidget: SvgPicture.asset(
          AppImage().emptyNotesIcon,
          width: 72.w,
          height: 72.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
