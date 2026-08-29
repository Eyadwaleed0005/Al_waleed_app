import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyLessonsContent extends StatelessWidget {
  const EmptyLessonsContent({super.key});
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,

    children: [
      Container(
        width: 136.w,
        height: 136.w,
        decoration: const BoxDecoration(
          color: ColorPalette.disabled,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          AppImage().emptyBookOpen,
          width: 102.w,
          height: 102.h,
        ),
      ),
      verticalSpace(36),
      Text(
        'لا توجد دروس متاحة حالياً',
        style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
      ),
    ],
  );
}
