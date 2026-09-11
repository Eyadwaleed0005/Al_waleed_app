import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_list.dart';
import 'package:flutter/material.dart';

class LessonsSuccessView extends StatelessWidget {
  final List<LessonEntity> lessons;
  final String query;
  final bool hasNoResults;
  final ValueChanged<LessonEntity> onLessonTap;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;

  const LessonsSuccessView({
    super.key,
    required this.lessons,
    required this.query,
    required this.hasNoResults,
    required this.onLessonTap,
    required this.onSearchChanged,
    required this.onSearchClear,
  });

  @override
  Widget build(BuildContext context) {
    return LessonsScreenList(
      lessons: lessons,
      query: query,
      hasNoResults: hasNoResults,
      onLessonTap: onLessonTap,
      onSearchChanged: onSearchChanged,
      onSearchClear: onSearchClear,
    );
  }
}
