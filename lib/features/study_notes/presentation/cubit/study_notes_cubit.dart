import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotesCubit extends Cubit<StudyNotesState> {
  final StreamStudyNotesUseCase _streamStudyNotesUseCase;

  StudyNotesCubit({required StreamStudyNotesUseCase streamStudyNotesUseCase})
    : _streamStudyNotesUseCase = streamStudyNotesUseCase,
      super(const StudyNotesInitial());

  StreamSubscription<Either<AppErrorModel, List<StudyNoteEntity>>>?
  _notesSubscription;

  bool _isInitializing = false;
  bool _isClosing = false;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> initialize() async {
    if (_isInitializing || !_canEmit) return;

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (!_canEmit) return;

      emit(const StudyNotesLoading());

      if (!_canEmit) return;

      _watchStudyNotes();
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void _watchStudyNotes() {
    if (!_canEmit) return;

    _notesSubscription = _streamStudyNotesUseCase().listen(_onStudyNotesResult);
  }

  void _onStudyNotesResult(
    Either<AppErrorModel, List<StudyNoteEntity>> result,
  ) {
    if (!_canEmit) return;

    result.fold(_emitFailure, _emitNotes);
  }

  void _emitNotes(List<StudyNoteEntity> notes) {
    if (!_canEmit) return;

    if (notes.isEmpty) {
      emit(const StudyNotesEmpty());
      return;
    }

    emit(
      StudyNotesDataSuccess(notes: List<StudyNoteEntity>.unmodifiable(notes)),
    );
  }

  void _emitFailure(AppErrorModel error) {
    if (!_canEmit) return;

    emit(StudyNotesFailure(error: error));
  }

  Future<void> _cancelSubscription() async {
    final subscription = _notesSubscription;
    _notesSubscription = null;

    await subscription?.cancel();
  }

  @override
  Future<void> close() async {
    if (_isClosing || isClosed) return;

    _isClosing = true;

    await _cancelSubscription();
    await super.close();
  }
}
