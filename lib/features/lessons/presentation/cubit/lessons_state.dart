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
  final AppErrorModel error;

  const LessonsFailure({required this.error});
}

final class LessonsDataSuccess extends LessonsState {
  final List<LessonEntity> lessons;

  const LessonsDataSuccess({required this.lessons});
}