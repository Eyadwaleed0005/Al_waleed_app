import 'dart:async';

import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_dialog.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_question_entity.dart';
import 'package:al_waleed/features/exams/presentation/cubit/pending_exam_submissions_sync_cubit.dart';
import 'package:al_waleed/features/exams/presentation/cubit/start_exam_screen_cubit.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/exam_navigation_actions.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/exam_question_card.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/finish_exam_confirmation_dialog.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/start_exam_progress_header.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/start_exam_timer.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartExamScreenContent extends StatefulWidget {
  const StartExamScreenContent({super.key});

  @override
  State<StartExamScreenContent> createState() {
    return _StartExamScreenContentState();
  }
}

class _StartExamScreenContentState extends State<StartExamScreenContent> {
  late final PageController _pageController;

  PendingExamSubmissionsSyncCubit? _pendingSubmissionsSyncCubit;

  bool _isFinishDialogVisible = false;
  bool _isFailureDialogVisible = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_pendingSubmissionsSyncCubit != null) {
      return;
    }

    final PendingExamSubmissionsSyncCubit syncCubit = context
        .read<PendingExamSubmissionsSyncCubit>();

    _pendingSubmissionsSyncCubit = syncCubit;

    syncCubit.pauseAutomaticSync();
  }

  @override
  void dispose() {
    _pendingSubmissionsSyncCubit?.resumeAutomaticSync();

    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartExamScreenCubit, StartExamScreenState>(
      listenWhen:
          (StartExamScreenState previous, StartExamScreenState current) {
            return current is StartExamScreenActionFailure ||
                current is StartExamScreenResultReady;
          },
      listener: _handleStateListener,
      builder: _buildState,
    );
  }

  Widget _buildState(BuildContext context, StartExamScreenState state) {
    if (state is StartExamScreenInitial ||
        state is StartExamScreenLoading ||
        state is StartExamScreenResultReady) {
      return const ProfileBackground(
        child: SafeArea(
          child: Center(
            child: AppLoadingIndicator(
              color: ColorPalette.primary,
              size: 38,
              strokeWidth: 4,
              wavelength: 16,
              waveSpeed: 10,
            ),
          ),
        ),
      );
    }

    if (state is StartExamScreenFailure) {
      return ProfileBackground(
        child: SafeArea(
          child: AppErrorState(
            message: state.error.message,
            onRetry: context.read<StartExamScreenCubit>().retryLoading,
          ),
        ),
      );
    }

    if (state is StartExamScreenDataState) {
      return _buildExamContent(context: context, state: state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildExamContent({
    required BuildContext context,
    required StartExamScreenDataState state,
  }) {
    final StartExamScreenCubit cubit = context.read<StartExamScreenCubit>();

    final bool isSubmitting = state is StartExamScreenSubmitting;

    final bool canInteract =
        !isSubmitting &&
        !state.isTimeExpired &&
        !state.cachedAttempt.isPendingSubmission;

    return ProfileBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            children: [
              CustomAppBar(
                backgroundColor: Colors.transparent,
                showBackButton: false,
                titleWidget: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      StartExamTimer(
                        remainingDuration: state.remainingDuration,
                      ),
                      horizontalSpace(12),
                      Expanded(
                        child: Text(
                          state.session.exam.examName,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              StartExamProgressHeader(
                currentQuestion: state.currentQuestionIndex + 1,
                totalQuestions: state.totalQuestionsCount,
                completionPercentage: state.completionPercentage,
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: IgnorePointer(
                  ignoring: !canInteract,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: canInteract
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    onPageChanged: cubit.changeQuestion,
                    itemCount: state.session.questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final StudentExamQuestionEntity question =
                          state.session.questions[index];

                      final int? selectedChoiceIndex = state
                          .selectedChoiceIndexFor(question.questionId);

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ExamQuestionCard(
                          questionText: question.questionText,
                          imageQuestion: question.questionImageUrl,
                          options: question.choices,
                          selectedIndex: selectedChoiceIndex,
                          isEnabled: canInteract,
                          onOptionSelected: (int choiceIndex) {
                            final int? updatedChoiceIndex =
                                selectedChoiceIndex == choiceIndex
                                ? null
                                : choiceIndex;

                            unawaited(
                              cubit.saveAnswer(
                                questionId: question.questionId,
                                selectedChoiceIndex: updatedChoiceIndex,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              ExamNavigationActions(
                isSubmitting: isSubmitting,
                onPreviousPressed: canInteract && !state.isFirstQuestion
                    ? _goToPreviousQuestion
                    : null,
                onNextPressed: canInteract && !state.isLastQuestion
                    ? _goToNextQuestion
                    : null,
                onSubmitPressed: canInteract
                    ? () {
                        unawaited(
                          _showFinishExamDialog(context: context, state: state),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, StartExamScreenState state) {
    if (state is StartExamScreenActionFailure) {
      unawaited(_showActionFailureDialog(context: context, state: state));

      return;
    }

    if (state is StartExamScreenResultReady) {
      Navigator.of(context).pushReplacementNamed(
        RouteNames.resultExamScreen,
        arguments: state.result,
      );
    }
  }

  void _goToPreviousQuestion() {
    if (!_pageController.hasClients) {
      return;
    }

    unawaited(
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  void _goToNextQuestion() {
    if (!_pageController.hasClients) {
      return;
    }

    unawaited(
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _showFinishExamDialog({
    required BuildContext context,
    required StartExamScreenDataState state,
  }) async {
    if (_isFinishDialogVisible ||
        state.isTimeExpired ||
        state.cachedAttempt.isPendingSubmission) {
      return;
    }

    _isFinishDialogVisible = true;

    final StartExamScreenCubit cubit = context.read<StartExamScreenCubit>();

    await FinishExamConfirmationDialog.show(
      context,
      answeredCount: state.answeredQuestionsCount,
      totalQuestions: state.totalQuestionsCount,
      onConfirmFinish: () {
        if (!cubit.isClosed) {
          unawaited(cubit.submitExam(isAutomatic: false));
        }
      },
    );

    _isFinishDialogVisible = false;
  }

  Future<void> _showActionFailureDialog({
    required BuildContext context,
    required StartExamScreenActionFailure state,
  }) async {
    if (_isFailureDialogVisible) {
      return;
    }

    _isFailureDialogVisible = true;

    final StartExamScreenCubit cubit = context.read<StartExamScreenCubit>();

    final bool? shouldRetry = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: CustomOperationResultDialog(
            type: CustomOperationResultType.failure,
            title: state.isSubmissionFailure
                ? 'تعذر تسليم الاختبار'
                : 'تعذر حفظ الإجابة',
            message: state.error.message,
            actionText: state.isSubmissionFailure ? 'إعادة المحاولة' : 'حسنًا',
            secondaryActionText: state.isSubmissionFailure
                ? 'المحاولة لاحقًا'
                : null,
            onActionPressed: () {
              Navigator.of(dialogContext).pop(state.isSubmissionFailure);
            },
            onSecondaryActionPressed: state.isSubmissionFailure
                ? () {
                    unawaited(
                      _confirmAttemptLater(failureDialogContext: dialogContext),
                    );
                  }
                : null,
          ),
        );
      },
    );

    _isFailureDialogVisible = false;

    if (!mounted || cubit.isClosed) {
      return;
    }

    if (!state.isSubmissionFailure) {
      cubit.restoreExamState();

      return;
    }

    if (shouldRetry == true) {
      await cubit.submitExam(isAutomatic: state.isTimeExpired);

      return;
    }

    if (shouldRetry == false && Navigator.of(context).canPop()) {
      Navigator.of(context).pop<String>(state.session.exam.examId);
    }
  }

  Future<void> _confirmAttemptLater({
    required BuildContext failureDialogContext,
  }) async {
    final bool? isConfirmed = await CustomDialog.showConfirm(
      failureDialogContext,
      title: 'المحاولة لاحقًا',
      message:
          'سيتم إرسال إجاباتك تلقائيًا عند إمكانية الإرسال، '
          'لكن لن تتمكن من معرفة النتيجة من داخل التطبيق. '
          'لمعرفة النتيجة تواصل مع المعلم.',
      primaryText: 'المحاولة لاحقًا',
      secondaryText: 'العودة',
      icon: Icons.info_outline_rounded,
    );
    if (isConfirmed != true || !failureDialogContext.mounted) {
      return;
    }
    Navigator.of(failureDialogContext).pop(false);
  }
}
