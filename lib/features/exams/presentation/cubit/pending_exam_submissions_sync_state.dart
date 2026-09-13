import 'package:al_waleed/core/errors/error_model/app_error_model.dart';

sealed class PendingExamSubmissionsSyncState {
  const PendingExamSubmissionsSyncState();
}

final class PendingExamSubmissionsSyncInitial
    extends PendingExamSubmissionsSyncState {
  const PendingExamSubmissionsSyncInitial();
}

final class PendingExamSubmissionsSyncInProgress
    extends PendingExamSubmissionsSyncState {
  const PendingExamSubmissionsSyncInProgress();
}

final class PendingExamSubmissionsSyncSuccess
    extends PendingExamSubmissionsSyncState {
  const PendingExamSubmissionsSyncSuccess();
}

final class PendingExamSubmissionsSyncFailure
    extends PendingExamSubmissionsSyncState {
  const PendingExamSubmissionsSyncFailure({required this.error});

  final AppErrorModel error;
}
