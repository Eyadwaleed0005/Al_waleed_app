import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/custom_search_bar.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_category_card.dart';
import 'package:flutter/material.dart';

class LessonsCategoryContent extends StatelessWidget {
  const LessonsCategoryContent({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      verticalSpace(12),
      const CustomSearchBar(hintText: 'ابحث عن درس...'),
      verticalSpace(48),
      LessonCategoryCard(
        title: 'الاتزان الكيميائي',
        subtitle: 'التفاعلات التامة والعكسية',
        onTap: () {
          Navigator.of(context).pushNamed(RouteNames.lessonDetails);
        },
      ),
      verticalSpace(22),
      LessonCategoryCard(
        title: 'الكيمياء العضوية',
        subtitle: 'أنواع المواد العضوية',
        onTap: () {
          Navigator.of(context).pushNamed(RouteNames.lessonDetails);
        },
      ),
    ],
  );
}
