import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/get_study_note_pdf_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_note_pdf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotePdfCubit extends Cubit<StudyNotePdfState> {
  final GetStudyNotePdfUseCase _getStudyNotePdfUseCase;

  StudyNotePdfCubit({required this._getStudyNotePdfUseCase})
    : super(const StudyNotePdfInitial());

  bool _isClosing = false;
  bool _isLoading = false;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> loadPdf({required StudyNoteEntity note}) async {
    if (_isLoading || !_canEmit) return;

    _isLoading = true;

    try {
      emit(const StudyNotePdfLoading());

      final result = await _getStudyNotePdfUseCase(note: note);

      if (!_canEmit) return;

      result.fold(
        (error) {
          if (!_canEmit) return;

          emit(StudyNotePdfFailure(error: error));
        },
        (pdf) {
          if (!_canEmit) return;

          emit(StudyNotePdfSuccess(pdfBytes: pdf.bytes));
        },
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> retry({required StudyNoteEntity note}) {
    return loadPdf(note: note);
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;

    await super.close();
  }
}
