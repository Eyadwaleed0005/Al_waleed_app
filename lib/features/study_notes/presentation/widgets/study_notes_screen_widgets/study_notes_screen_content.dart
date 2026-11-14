import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_empty_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_error_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_loading_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudyNotesScreenContent extends StatefulWidget {
  const StudyNotesScreenContent({super.key});

  @override
  State<StudyNotesScreenContent> createState() {
    return _StudyNotesScreenContentState();
  }
}

class _StudyNotesScreenContentState extends State<StudyNotesScreenContent> {
  bool _isOpeningNote = false;

  Future<void> _openNote(StudyNoteEntity note) async {
    if (_isOpeningNote) return;

    _isOpeningNote = true;

    final cubit = context.read<StudyNotesCubit>();

    try {
      final result = await cubit.checkStudyNoteAccess(studyNote: note);

      if (!mounted) return;

      await result.fold<Future<void>>(
        (error) {
          return _showAccessError(error.message);
        },
        (canAccess) async {
          if (!canAccess) {
            await _showSubscriptionDialog();
            return;
          }

          await Navigator.of(
            context,
          ).pushNamed(RouteNames.studyNotePdfReaderScreen, arguments: note);
        },
      );
    } finally {
      _isOpeningNote = false;
    }
  }

  Future<void> _showAccessError(String message) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: 'تعذر التحقق من الاشتراك',
          message: message,
          actionText: 'حسنًا',
        );
      },
    );
  }

  Future<void> _showSubscriptionDialog() async {
    final openSubscription = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          failureIcon: Icons.lock_outline_rounded,
          title: 'هذه المذكرة تحتاج إلى اشتراك',
          message:
              'لمشاهدة هذه المذكرة، '
              'تواصل مع المعلّم لتفعيل اشتراكك أو تجديده.',
          actionText: 'تفعيل الاشتراك',
          secondaryActionText: 'إلغاء',
          onActionPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
          onSecondaryActionPressed: () {
            Navigator.of(dialogContext).pop(false);
          },
        );
      },
    );

    if (!mounted || openSubscription != true) return;

    final cubit = context.read<StudyNotesCubit>();

    await Navigator.of(context).pushNamed(RouteNames.mySubscriptionScreen);

    if (!mounted || cubit.isClosed) return;

    await cubit.refreshSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      CustomAppBar(
                        title: 'المذكرات',
                        backgroundColor: Colors.transparent,
                        showBackButton: false,
                        actions: [
                          SvgPicture.asset(
                            AppImage().studyNotes,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ],
                      ),
                      verticalSpace(24),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<StudyNotesCubit, StudyNotesState>(
              builder: (context, state) {
                if (state is StudyNotesInitial || state is StudyNotesLoading) {
                  return const StudyNotesLoadingView();
                }

                if (state is StudyNotesFailure) {
                  return StudyNotesErrorView(
                    errorMessage: state.error.message,
                    onRetry: context.read<StudyNotesCubit>().retry,
                  );
                }

                if (state is StudyNotesEmpty) {
                  return const StudyNotesEmptyView();
                }

                if (state is StudyNotesDataSuccess) {
                  final cubit = context.read<StudyNotesCubit>();

                  return StudyNotesSuccessView(
                    notes: state.notes,
                    showFree: state.showFree,
                    hasValidSubscription: state.hasValidSubscription,
                    onAccessTypeChanged: cubit.selectAccessType,
                    onNoteTap: _openNote,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
