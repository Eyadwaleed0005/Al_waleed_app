import 'dart:async';

import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_dialog.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/presentation/cubit/exams_screen_cubit.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/exams_screen_state_widgets/exams_screen_empty_view.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/exams_screen_state_widgets/exams_screen_loading_view.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/exams_screen_state_widgets/exams_screen_success_view.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamsScreenContent extends StatelessWidget {
  const ExamsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'الامتحانات',
              centerTitle: true,
              showBackButton: false,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: BlocConsumer<ExamsScreenCubit, ExamsScreenState>(
                listenWhen:
                    (ExamsScreenState previous, ExamsScreenState current) {
                      return current is ExamsScreenActionFailure ||
                          current is ExamsScreenSessionReady;
                    },
                listener: _handleStateListener,
                builder: _buildState,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, ExamsScreenState state) {
    if (state is ExamsScreenInitial || state is ExamsScreenLoading) {
      return const ExamsScreenLoadingView();
    }

    if (state is ExamsScreenEmpty) {
      return const ExamsScreenEmptyView();
    }

    if (state is ExamsScreenFailure) {
      return AppErrorState(
        message: state.error.message,
        onRetry: context.read<ExamsScreenCubit>().retryLoading,
      );
    }

    if (state is ExamsScreenOpeningExam) {
      return ExamsScreenSuccessView(
        exams: state.exams,
        openingExamId: state.examId,
        onExamPressed: (StudentExamListItemEntity examItem) {
          _handleExamPressed(context: context, examItem: examItem);
        },
      );
    }

    if (state is ExamsScreenSuccess) {
      return ExamsScreenSuccessView(
        exams: state.exams,
        onExamPressed: (StudentExamListItemEntity examItem) {
          _handleExamPressed(context: context, examItem: examItem);
        },
      );
    }

    if (state is ExamsScreenSessionReady) {
      return ExamsScreenSuccessView(
        exams: state.exams,
        onExamPressed: (StudentExamListItemEntity examItem) {
          _handleExamPressed(context: context, examItem: examItem);
        },
      );
    }

    if (state is ExamsScreenActionFailure) {
      return ExamsScreenSuccessView(
        exams: state.exams,
        onExamPressed: (StudentExamListItemEntity examItem) {
          _handleExamPressed(context: context, examItem: examItem);
        },
      );
    }

    return const ExamsScreenLoadingView();
  }

  void _handleStateListener(BuildContext context, ExamsScreenState state) {
    if (state is ExamsScreenActionFailure) {
      unawaited(_showActionFailureDialog(context: context, state: state));

      return;
    }

    if (state is ExamsScreenSessionReady) {
      unawaited(_openExamSession(context: context, state: state));
    }
  }

  void _handleExamPressed({
    required BuildContext context,
    required StudentExamListItemEntity examItem,
  }) {
    if (examItem.hasAttempt) {
      unawaited(context.read<ExamsScreenCubit>().openExam(examItem: examItem));

      return;
    }

    unawaited(_confirmStartingExam(context: context, examItem: examItem));
  }

  Future<void> _confirmStartingExam({
    required BuildContext context,
    required StudentExamListItemEntity examItem,
  }) async {
    final ExamsScreenCubit cubit = context.read<ExamsScreenCubit>();

    final bool? isConfirmed = await CustomDialog.showConfirm(
      context,
      title: 'بدء الامتحان',
      message:
          'بمجرد بدء الامتحان سيبدأ احتساب الوقت '
          'ولن تتمكن من إعادة المحاولة.',
      primaryText: 'ابدأ الامتحان',
      secondaryText: 'إلغاء',
      icon: Icons.timer_outlined,
    );

    if (isConfirmed != true || cubit.isClosed) {
      return;
    }

    await cubit.openExam(examItem: examItem);
  }

  Future<void> _showActionFailureDialog({
    required BuildContext context,
    required ExamsScreenActionFailure state,
  }) async {
    final ExamsScreenCubit cubit = context.read<ExamsScreenCubit>();

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: 'تعذر فتح الاختبار',
          message: state.error.message,
          actionText: 'حسنًا',
        );
      },
    );

    if (!cubit.isClosed) {
      cubit.restoreExamsState();
    }
  }

  Future<void> _openExamSession({
    required BuildContext context,
    required ExamsScreenSessionReady state,
  }) async {
    final ExamsScreenCubit cubit = context.read<ExamsScreenCubit>();

    final String? pendingExamId = await Navigator.of(
      context,
    ).pushNamed<String>(RouteNames.startExamScreen, arguments: state.session);

    if (cubit.isClosed) {
      return;
    }

    if (pendingExamId != null && pendingExamId.trim().isNotEmpty) {
      cubit.hideExam(examId: pendingExamId);

      return;
    }

    cubit.restoreExamsState();
  }
}
