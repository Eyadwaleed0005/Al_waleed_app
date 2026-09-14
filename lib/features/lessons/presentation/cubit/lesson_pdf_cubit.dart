import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/use_case/get_lesson_pdf_use_case.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonPdfCubit extends Cubit<LessonPdfState> {
  LessonPdfCubit({required GetLessonPdfUseCase getLessonPdfUseCase})
    : _getLessonPdfUseCase = getLessonPdfUseCase,
      super(const LessonPdfInitial());

  final GetLessonPdfUseCase _getLessonPdfUseCase;

  bool _isLoading = false;

  Future<void> loadPdf({required LessonEntity lesson}) async {
    if (_isLoading || isClosed) {
      return;
    }

    if (!lesson.hasPdfFile) {
      emit(const LessonPdfEmpty());
      return;
    }

    _isLoading = true;
    emit(const LessonPdfLoading());

    try {
      final result = await _getLessonPdfUseCase(lesson: lesson);

      if (isClosed) {
        return;
      }

      result.fold(
        (error) {
          emit(LessonPdfFailure(error: error));
        },
        (pdf) {
          if (pdf.bytes.isEmpty) {
            emit(const LessonPdfEmpty());
            return;
          }

          emit(LessonPdfSuccess(pdfBytes: pdf.bytes));
        },
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> retry({required LessonEntity lesson}) {
    return loadPdf(lesson: lesson);
  }
}
