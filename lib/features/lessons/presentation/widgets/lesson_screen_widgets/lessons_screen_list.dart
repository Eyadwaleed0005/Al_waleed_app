import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/core/widgets/custom_search_bar.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lesson_preview_card.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_access_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsScreenList extends StatefulWidget {
  const LessonsScreenList({
    super.key,
    required this.lessons,
    required this.onLessonTap,
    required this.hasValidSubscription,
    required this.showFree,
    required this.onAccessTypeChanged,
    this.query = '',
    this.hasNoResults = false,
    this.onSearchChanged,
    this.onSearchClear,
  });

  final List<LessonEntity> lessons;
  final ValueChanged<LessonEntity> onLessonTap;
  final bool? hasValidSubscription;
  final bool showFree;
  final ValueChanged<bool> onAccessTypeChanged;
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
  void didUpdateWidget(covariant LessonsScreenList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != oldWidget.query &&
        _searchController.text != widget.query) {
      _searchController.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

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
        verticalSpace(16),
        LessonsAccessFilter(
          showFree: widget.showFree,
          onChanged: widget.onAccessTypeChanged,
        ),
        verticalSpace(24),
        if (widget.hasNoResults)
          _buildEmptyView(
            title: 'لا توجد نتائج مطابقة لبحثك',
            subtitle: 'جرّب تعديل كلمة البحث أو امسحها لعرض دروس هذا القسم',
            icon: Icons.search_off_rounded,
          )
        else if (widget.lessons.isEmpty)
          _buildEmptyView(
            title: widget.showFree
                ? 'لا توجد دروس مجانية حاليًا'
                : 'لا توجد دروس مدفوعة حاليًا',
            subtitle: 'يمكنك تصفّح القسم الآخر',
            icon: Icons.video_library_outlined,
          )
        else
          for (var index = 0; index < widget.lessons.length; index++) ...[
            KeyedSubtree(
              key: ValueKey(widget.lessons[index].lessonId),
              child: AppAnimations.screenSection(
                delay: 60 * index,
                child: LessonPreviewCard(
                  lessonId: widget.lessons[index].lessonId,
                  title: widget.lessons[index].title,
                  subtitle: widget.lessons[index].description,
                  youtubeUrl: widget.lessons[index].youtubeUrl,
                  isFree: widget.lessons[index].isFree,
                  hasValidSubscription: widget.hasValidSubscription,
                  onTap: () => widget.onLessonTap(widget.lessons[index]),
                ),
              ),
            ),
            if (index != widget.lessons.length - 1) verticalSpace(22),
          ],
      ],
    );
  }

  Widget _buildEmptyView({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return SizedBox(
      height: 320.h,
      child: AppEmptyState(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconContainerSize: 112,
        iconBackgroundColor: ColorPalette.accent.withValues(alpha: 0.55),
        iconTitleSpacing: 28,
      ),
    );
  }
}
