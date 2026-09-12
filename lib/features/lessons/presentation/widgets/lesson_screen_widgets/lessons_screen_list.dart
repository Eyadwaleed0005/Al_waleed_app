import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/core/widgets/custom_search_bar.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lesson_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsScreenList extends StatefulWidget {
  const LessonsScreenList({
    super.key,
    required this.lessons,
    required this.onLessonTap,
    this.query = '',
    this.hasNoResults = false,
    this.onSearchChanged,
    this.onSearchClear,
  });

  final List<LessonEntity> lessons;
  final ValueChanged<LessonEntity> onLessonTap;
  final String query;
  final bool hasNoResults;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;

  @override
  State<LessonsScreenList> createState() => _LessonsScreenListState();
}

class _LessonsScreenListState extends State<LessonsScreenList> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.query,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 12.h, bottom: 100.h),
      children: [
        CustomSearchBar(
          controller: _searchController,
          hintText: 'ابحث عن درس',
          onChanged: widget.onSearchChanged,
          onClear: () {
            _searchController.clear();
            widget.onSearchClear?.call();
          },
        ),
        verticalSpace(48),
        if (widget.hasNoResults)
          _buildNoResultsView()
        else
          for (var index = 0; index < widget.lessons.length; index++) ...[
            AppAnimations.screenSection(
              delay: 60 * index,
              child: LessonPreviewCard(
                title: widget.lessons[index].title,
                subtitle: widget.lessons[index].description,
                onTap: () => widget.onLessonTap(widget.lessons[index]),
              ),
            ),
            if (index != widget.lessons.length - 1) verticalSpace(22),
          ],
      ],
    );
  }

  Widget _buildNoResultsView() {
    return SizedBox(
      height: 320.h,
      child: AppEmptyState(
        title: 'لا توجد نتائج مطابقة لبحثك',
        subtitle: 'جرّب تعديل كلمة البحث أو امسحها لعرض جميع الدروس',
        icon: Icons.search_off_rounded,
        iconContainerSize: 112,
        iconBackgroundColor: ColorPalette.accent.withOpacity(0.55),
        iconTitleSpacing: 28,
      ),
    );
  }
}
