import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/custom_search_bar.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lesson_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsScreenList extends StatelessWidget {
  const LessonsScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 12.h, bottom: 100.h),
      children: [
        const CustomSearchBar(hintText: 'ابحث عن درس...'),
        verticalSpace(48),
        LessonPreviewCard(
          title: 'الاتزان الكيميائي',
          subtitle: 'التفاعلات التامة والعكسية',
          onTap: () {
            Navigator.of(context).pushNamed(RouteNames.lessonDetails);
          },
        ),
        verticalSpace(22),
        LessonPreviewCard(
          title: 'الكيمياء العضوية',
          subtitle: 'أنواع المواد العضوية',
          onTap: () {
            Navigator.of(context).pushNamed(RouteNames.lessonDetails);
          },
        ),
      ],
    );
  }
}
