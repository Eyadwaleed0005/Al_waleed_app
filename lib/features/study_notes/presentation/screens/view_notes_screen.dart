import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/mock_study_notes_data_source.dart';
import 'package:al_waleed/features/study_notes/data/repositories/study_notes_repository_impl.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/view_notes_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/notes_header.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewNotesScreen extends StatelessWidget {
  const ViewNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewNotesCubit(GetStudyNotesUseCase(StudyNotesRepositoryImpl(MockStudyNotesDataSource())))..loadNotes(),
      child: BackgroundStudentLayout(
        child: Column(
          children: [
            const NotesHeader(title: 'المذكرة'),
            Expanded(
              child: BlocBuilder<ViewNotesCubit, ViewNotesState>(
                builder: (context, state) {
                  if (state is ViewNotesFailure) {
                    return AppErrorState(message: state.message, onRetry: () => context.read<ViewNotesCubit>().loadNotes());
                  }

                  if (state is ViewNotesLoaded) {
                    if (state.notes.isEmpty) {
                      return const _EmptyNotesState();
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: StudyNotesList(
                        notes: state.notes,
                        onNoteTap: (note) {
                          Navigator.of(context).pushNamed(RouteNames.noteReader, arguments: note);
                        },
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator(color: ColorPalette.primary));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotesState extends StatelessWidget {
  const _EmptyNotesState();

  @override
  Widget build(BuildContext context) {
    return AppAnimations.emptyStateEntrance(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 140.w,
                height: 140.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: ColorPalette.textMuted.withValues(alpha: 0.5), shape: BoxShape.circle),
                child: Image.asset(AppImage().emptyNotesIcon, width: 60.w, height: 60.w),
              ),
              verticalSpace(20),
              Text('لا توجد مذكرات متاحة حاليًا', textAlign: TextAlign.center, style: AppTextStyle.font20TextPrimarySemiBoldKufam()),
            ],
          ),
        ),
      ),
    );
  }
}
