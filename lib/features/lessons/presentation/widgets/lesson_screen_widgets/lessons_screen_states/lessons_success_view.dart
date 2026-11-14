import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_list.dart';
import 'package:flutter/material.dart';

class LessonsSuccessView extends StatelessWidget {
  const LessonsSuccessView({
    super.key,
    required this.lessons,
    required this.query,
    required this.showFree,
    required this.hasNoResults,
    required this.hasValidSubscription,
    required this.onAccessTypeChanged,
    required this.onLessonTap,
    required this.onSearchChanged,
    required this.onSearchClear,
  });

  final List<LessonEntity> lessons;
  final String query;
  final bool showFree;
  final bool hasNoResults;
  final bool? hasValidSubscription;
  final ValueChanged<bool> onAccessTypeChanged;
  final ValueChanged<LessonEntity> onLessonTap;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;

  @override
  Widget build(BuildContext context) {
    return LessonsScreenList(
      lessons: lessons,
      query: query,
      showFree: showFree,
      hasNoResults: hasNoResults,
      hasValidSubscription: hasValidSubscription,
      onAccessTypeChanged: onAccessTypeChanged,
      onLessonTap: onLessonTap,
      onSearchChanged: onSearchChanged,
      onSearchClear: onSearchClear,
    );
  }
}
