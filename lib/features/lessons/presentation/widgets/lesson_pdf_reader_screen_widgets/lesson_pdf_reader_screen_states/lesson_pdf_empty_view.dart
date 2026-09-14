import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_state_layout.dart';
import 'package:flutter/material.dart';

class LessonPdfEmptyView extends StatelessWidget {
  const LessonPdfEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) ==
        Orientation.landscape;

    final iconContainerSize =
        isLandscape ? 80.0 : 136.0;

    final iconSize =
        isLandscape ? 58.0 : 102.0;

    final iconTitleSpacing =
        isLandscape ? 12.0 : 36.0;

    final titleStyle = AppTextStyle
        .font20TextPrimarySemiBoldKufam()
        .copyWith(
          fontSize: isLandscape ? 15 : null,
        );

    return LessonPdfStateLayout(
      child: AppEmptyState(
        title: 'لا يوجد ملف للدرس حاليًا',
        titleStyle: titleStyle,
        iconContainerSize: iconContainerSize,
        iconBackgroundColor:
            ColorPalette.disabled,
        iconTitleSpacing: iconTitleSpacing,
        iconWidget: Image.asset(
          AppImage().emptyBookOpen,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}