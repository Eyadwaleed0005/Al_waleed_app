import 'package:al_waleed/core/errors/error_model/app_error_model.dart';

sealed class StudentGradeSyncState {
  const StudentGradeSyncState();
}

final class StudentGradeSyncInitial extends StudentGradeSyncState {
  const StudentGradeSyncInitial();
}

final class StudentGradeSyncLoading extends StudentGradeSyncState {
  const StudentGradeSyncLoading();
}

final class StudentGradeSyncSuccess extends StudentGradeSyncState {
  const StudentGradeSyncSuccess({
    required this.gradeId,
  });

  final String gradeId;
}

final class StudentGradeSyncFailure extends StudentGradeSyncState {
  const StudentGradeSyncFailure({
    required this.error,
  });

  final AppErrorModel error;
}