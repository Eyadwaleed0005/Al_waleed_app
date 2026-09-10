import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_list_view.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_screen_widgets/study_notes_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesScreenContent extends StatefulWidget {
  const StudyNotesScreenContent({super.key});

  @override
  State<StudyNotesScreenContent> createState() =>
      _StudyNotesScreenContentState();
}

class _StudyNotesScreenContentState extends State<StudyNotesScreenContent> {
  late final StudyNotesCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<StudyNotesCubit>();

    _cubit.initialize();
  }

  void _onNoteTap(StudyNoteEntity note) {
    Navigator.of(context).pushNamed(
      RouteNames.studyNotePdfReaderScreen,
      arguments: note,
    );
  }

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
                  Image.asset(
                    AppImage().studyNotes,
                    width: 24.w,
                    height: 24.h,
                  ),
                ],
              ),
              verticalSpace(24),
              Expanded(
                child: BlocBuilder<StudyNotesCubit, StudyNotesState>(
                  builder: (context, state) {
                    if (state is StudyNotesLoading) {
                      return const StudyNotesLoadingSkeleton();
                    }

                    if (state is StudyNotesFailure) {
                      return AppErrorState(
                        message: state.error.message,
                        onRetry: () {
                          _cubit.retry();
                        },
                      );
                    }

                    if (state is StudyNotesDataSuccess) {
                      return StudyNotesListView(
                        notes: state.notes,
                        onNoteTap: _onNoteTap,
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
