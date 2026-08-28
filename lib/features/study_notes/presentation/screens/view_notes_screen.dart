import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/mock_study_notes_data_source.dart';
import 'package:al_waleed/features/study_notes/data/repositories/study_notes_repository_impl.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/view_notes_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/empty_notes_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/notes_header.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewNotesScreen extends StatelessWidget {
  const ViewNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: BlocProvider(
        create: (_) => ViewNotesCubit(
          GetStudyNotesUseCase(
            StudyNotesRepositoryImpl(MockStudyNotesDataSource()),
          ),
        )..loadNotes(),
        child: BackgroundStudentLayout(
          child: Column(
            children: [
              const NotesHeader(title: 'المذكرة'),
              Expanded(
                child: BlocBuilder<ViewNotesCubit, ViewNotesState>(
                  builder: (context, state) {
                    if (state is ViewNotesFailure) {
                      return AppErrorState(
                        message: state.message,
                        onRetry: () => context.read<ViewNotesCubit>().loadNotes(),
                      );
                    }

                    if (state is ViewNotesLoaded) {
                      if (state.notes.isEmpty) {
                        return const EmptyNotesState();
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: StudyNotesList(
                          notes: state.notes,
                          onNoteTap: (note) {
                            Navigator.of(context).pushNamed(
                              RouteNames.noteReader,
                              arguments: note,
                            );
                          },
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(color: ColorPalette.primary),
                    );
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
