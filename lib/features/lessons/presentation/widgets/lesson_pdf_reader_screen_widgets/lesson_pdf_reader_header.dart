import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LessonPdfReaderHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const LessonPdfReaderHeader({
    super.key,
    required this.lessonTitle,
    required this.isLandscape,
  });

  final String lessonTitle;
  final bool isLandscape;

  @override
  Size get preferredSize {
    return Size.fromHeight(isLandscape ? 48 : kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = isLandscape ? 48.0 : kToolbarHeight;

    final iconSize = isLandscape ? 22.0 : 26.0;

    final horizontalPadding = isLandscape ? 10.0 : 16.0;

    return CustomAppBar(
      toolbarHeight: toolbarHeight,
      titleWidget: Text.rich(
        TextSpan(
          text: isLandscape ? 'ملف الدرس' : 'ملف الدرس\n',
          style: AppTextStyle.font18CardBackgroundSemiBoldKufam().copyWith(
            fontSize: isLandscape ? 14 : 18,
          ),
          children: [
            TextSpan(
              text: isLandscape ? '  •  $lessonTitle' : lessonTitle,
              style: AppTextStyle.font12TextMutedRegularTajawal().copyWith(
                fontSize: isLandscape ? 11 : 12,
              ),
            ),
          ],
        ),
        maxLines: isLandscape ? 1 : 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
      backButtonColor: ColorPalette.cardBackground,
      backgroundColor: ColorPalette.primary,
      showBackButton: true,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Image.asset(
            AppImage().readerPdf,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            color: ColorPalette.cardBackground,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
