import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonPdfReaderHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const LessonPdfReaderHeader({super.key, required this.lessonTitle});

  final String lessonTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      titleWidget: RichText(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          text: 'ملف الدرس\n',
          style: AppTextStyle.font18CardBackgroundSemiBoldKufam(),
          children: [
            TextSpan(
              text: lessonTitle,
              style: AppTextStyle.font12TextMutedRegularTajawal(),
            ),
          ],
        ),
      ),
      backButtonColor: ColorPalette.cardBackground,
      backgroundColor: ColorPalette.primary,
      showBackButton: true,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Image.asset(
            AppImage().readerPdf,
            width: 26.w,
            height: 26.h,
            fit: BoxFit.contain,
            color: ColorPalette.cardBackground,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
