import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_cubit.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_state.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_screen_states/lesson_pdf_empty_view.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_screen_states/lesson_pdf_error_view.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_screen_states/lesson_pdf_loading_view.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_screen_states/lesson_pdf_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonPdfBody extends StatelessWidget {
  const LessonPdfBody({super.key, required this.lesson});

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonPdfCubit, LessonPdfState>(
      builder: (context, state) {
        if (state is LessonPdfFailure) {
          return LessonPdfErrorView(
            errorMessage: state.error.message,
            onRetry: () {
              context.read<LessonPdfCubit>().retry(lesson: lesson);
            },
          );
        }

        if (state is LessonPdfEmpty) {
          return const LessonPdfEmptyView();
        }

        if (state is LessonPdfSuccess) {
          return LessonPdfSuccessView(pdfBytes: state.pdfBytes);
        }

        return const LessonPdfLoadingView();
      },
    );
  }
}
