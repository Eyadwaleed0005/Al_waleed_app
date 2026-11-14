import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';

sealed class LessonsState {
  const LessonsState();
}

final class LessonsInitial extends LessonsState {
  const LessonsInitial();
}

final class LessonsLoading extends LessonsState {
  const LessonsLoading();
}

final class LessonsEmpty extends LessonsState {
  const LessonsEmpty();
}

final class LessonsFailure extends LessonsState {
  const LessonsFailure({required this.error});

  final AppErrorModel error;
}

final class LessonsDataSuccess extends LessonsState {
  const LessonsDataSuccess({
    required this.lessons,
    this.query = '',
    this.showFree = true,
    this.hasValidSubscription,
  });

  final List<LessonEntity> lessons;
  final String query;
  final bool showFree;
  final bool? hasValidSubscription;

  bool get hasActiveQuery => query.trim().isNotEmpty;

  bool get hasNoResults => hasActiveQuery && lessons.isEmpty;

  bool get hasNoLessonsInSection => !hasActiveQuery && lessons.isEmpty;
}
