import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LessonQuizEmptyView extends StatelessWidget {
  const LessonQuizEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        title: 'لا يوجد اختبار متاح حاليًا',
        titleStyle: AppTextStyle.font20TextPrimarySemiBoldKufam(),
        iconContainerSize: 136,
        iconBackgroundColor: ColorPalette.disabled,
        iconTitleSpacing: 36,
        iconWidget: SvgPicture.asset(
          AppImage().emptyBookOpen,
          width: 102.w,
          height: 102.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
