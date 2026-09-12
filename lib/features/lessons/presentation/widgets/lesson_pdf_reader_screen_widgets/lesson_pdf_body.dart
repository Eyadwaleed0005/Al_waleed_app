import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_cubit.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_state.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_document_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonPdfBody extends StatelessWidget {
  final LessonEntity lesson;

  const LessonPdfBody({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonPdfCubit, LessonPdfState>(
      builder: (context, state) {
        if (state is LessonPdfInitial || state is LessonPdfLoading) {
          return const Center(
            child: AppLoadingIndicator(
              color: ColorPalette.primary,
              size: 36,
              strokeWidth: 3,
            ),
          );
        }

        if (state is LessonPdfFailure) {
          return AppErrorState(
            message: state.error.message,
            onRetry: () {
              context.read<LessonPdfCubit>().retry(lesson: lesson);
            },
          );
        }

        if (state is LessonPdfSuccess) {
          return LessonPdfDocumentViewer(pdfBytes: state.pdfBytes);
        }

        return const SizedBox.shrink();
      },
    );
  }
}