import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/use_case/get_lesson_pdf_use_case.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonPdfCubit extends Cubit<LessonPdfState> {
  final GetLessonPdfUseCase _getLessonPdfUseCase;

  LessonPdfCubit({required this._getLessonPdfUseCase})
    : super(const LessonPdfInitial());

  bool _isClosing = false;
  bool _isLoading = false;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> loadPdf({required LessonEntity lesson}) async {
    if (_isLoading || !_canEmit) return;

    _isLoading = true;

    try {
      emit(const LessonPdfLoading());

      final result = await _getLessonPdfUseCase(lesson: lesson);

      if (!_canEmit) return;

      result.fold(
        (error) {
          if (!_canEmit) return;

          emit(LessonPdfFailure(error: error));
        },
        (pdf) {
          if (!_canEmit) return;

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

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;

    await super.close();
  }
}