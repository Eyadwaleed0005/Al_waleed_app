import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_empty_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_error_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_loading_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_screen_states/study_notes_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesScreenContent extends StatelessWidget {
  const StudyNotesScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              CustomAppBar(
                title: 'المذكرات',
                backgroundColor: Colors.transparent,
                showBackButton: false,
                actions: [
                  Image.asset(AppImage().studyNotes, width: 24.w, height: 24.h),
                ],
              ),
              verticalSpace(24),
              Expanded(
                child: BlocBuilder<StudyNotesCubit, StudyNotesState>(
                  builder: (context, state) {
                    if (state is StudyNotesInitial ||
                        state is StudyNotesLoading) {
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
                      return StudyNotesSuccessView(
                        notes: state.notes,
                        onNoteTap: (note) {
                          Navigator.of(context).pushNamed(
                            RouteNames.studyNotePdfReaderScreen,
                            arguments: note,
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
