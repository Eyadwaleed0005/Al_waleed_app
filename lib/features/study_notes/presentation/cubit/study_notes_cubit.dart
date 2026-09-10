import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotesCubit extends Cubit<StudyNotesState> {
  StudyNotesCubit({required this._streamStudyNotesUseCase})
    : super(const StudyNotesInitial());

  final StreamStudyNotesUseCase _streamStudyNotesUseCase;

  StreamSubscription<Either<AppErrorModel, List<StudyNoteEntity>>>?
  _notesSubscription;

  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitializing) return;

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (isClosed) return;

      emit(const StudyNotesLoading());

      _watchStudyNotes();
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() async {
    await initialize();
  }

  void _watchStudyNotes() {
    _notesSubscription = _streamStudyNotesUseCase(
      isPublished: true,
    ).listen(_onStudyNotesResult);
  }

  void _onStudyNotesResult(
    Either<AppErrorModel, List<StudyNoteEntity>> result,
  ) {
    if (isClosed) return;

    result.fold(
      (error) => _emitFailure(error),
      (notes) => _emitDataSuccess(notes: notes),
    );
  }

  void _emitDataSuccess({required List<StudyNoteEntity> notes}) {
    if (isClosed) return;

    emit(StudyNotesDataSuccess(notes: notes));
  }

  void _emitFailure(AppErrorModel error) {
    if (isClosed) return;

    emit(StudyNotesFailure(error: error));
  }

  Future<void> _cancelSubscription() async {
    await _notesSubscription?.cancel();

    _notesSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelSubscription();

    return super.close();
  }
}
