import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_note_pdf_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_note_pdf_state.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_pdf_reader_screen_widgets/study_note_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotePdfBody extends StatelessWidget {
  final StudyNoteEntity note;

  const StudyNotePdfBody({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyNotePdfCubit, StudyNotePdfState>(
      builder: (context, state) {
        if (state is StudyNotePdfInitial || state is StudyNotePdfLoading) {
          return const Center(
            child: AppLoadingIndicator(
              color: ColorPalette.primary,
              size: 36,
              strokeWidth: 3,
            ),
          );
        }

        if (state is StudyNotePdfFailure) {
          return AppErrorState(
            message: state.error.message,
            onRetry: () {
              context.read<StudyNotePdfCubit>().retry(note: note);
            },
          );
        }

        if (state is StudyNotePdfSuccess) {
          return StudyNotePdfViewer(pdfBytes: state.pdfBytes);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
