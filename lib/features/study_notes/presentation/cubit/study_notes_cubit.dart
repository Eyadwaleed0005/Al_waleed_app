import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/check_study_note_access_use_case.dart';
import 'package:al_waleed/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_notes_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotesCubit extends Cubit<StudyNotesState> {
  StudyNotesCubit({
    required StreamStudyNotesUseCase streamStudyNotesUseCase,
    required CheckStudyNoteAccessUseCase checkStudyNoteAccessUseCase,
  }) : _streamStudyNotesUseCase = streamStudyNotesUseCase,
       _checkStudyNoteAccessUseCase = checkStudyNoteAccessUseCase,
       super(const StudyNotesInitial());

  final StreamStudyNotesUseCase _streamStudyNotesUseCase;
  final CheckStudyNoteAccessUseCase _checkStudyNoteAccessUseCase;

  StreamSubscription<Either<AppErrorModel, List<StudyNoteEntity>>>?
  _notesSubscription;

  List<StudyNoteEntity> _allNotes = const [];

  bool _showFree = true;
  bool? _hasValidSubscription;
  AppErrorModel? _subscriptionError;

  bool _isInitializing = false;
  bool _isClosing = false;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> initialize() async {
    if (_isInitializing || !_canEmit) return;

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (!_canEmit) return;

      _allNotes = const [];
      _hasValidSubscription = null;
      _subscriptionError = null;

      emit(const StudyNotesLoading());

      final subscriptionResult = await _checkStudyNoteAccessUseCase
          .checkSubscription();

      if (!_canEmit) return;

      _updateSubscriptionStatus(subscriptionResult);

      _notesSubscription = _streamStudyNotesUseCase().listen(
        _onStudyNotesResult,
        onError: _onStreamError,
      );
    } catch (error) {
      _emitFailure(FirebaseErrorHandler.handle(error));
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void selectAccessType(bool showFree) {
    if (!_canEmit || _showFree == showFree) return;

    _showFree = showFree;

    if (state is StudyNotesDataSuccess) {
      _emitFilteredNotes();
    }
  }

  Future<Either<AppErrorModel, bool>> checkStudyNoteAccess({
    required StudyNoteEntity studyNote,
  }) async {
    final result = await _checkStudyNoteAccessUseCase(studyNote: studyNote);

    if (_canEmit && !studyNote.isFree) {
      _updateSubscriptionStatus(result);

      if (state is StudyNotesDataSuccess) {
        _emitFilteredNotes();
      }
    }

    return result;
  }

  Future<void> refreshSubscription() async {
    if (!_canEmit || _isInitializing) return;

    final result = await _checkStudyNoteAccessUseCase.checkSubscription();

    if (!_canEmit) return;

    _updateSubscriptionStatus(result);

    if (state is StudyNotesDataSuccess) {
      _emitFilteredNotes();
    }
  }

  void _updateSubscriptionStatus(Either<AppErrorModel, bool> result) {
    result.fold(
      (error) {
        _hasValidSubscription = null;
        _subscriptionError = error;
      },
      (hasValidSubscription) {
        _hasValidSubscription = hasValidSubscription;
        _subscriptionError = null;
      },
    );
  }

  void _onStudyNotesResult(
    Either<AppErrorModel, List<StudyNoteEntity>> result,
  ) {
    if (!_canEmit) return;

    result.fold(_emitFailure, _emitNotes);
  }

  void _emitNotes(List<StudyNoteEntity> notes) {
    if (!_canEmit) return;

    _allNotes = List<StudyNoteEntity>.unmodifiable(notes);

    if (_allNotes.isEmpty) {
      emit(const StudyNotesEmpty());
      return;
    }

    _emitFilteredNotes();
  }

  void _emitFilteredNotes() {
    if (!_canEmit) return;

    final filteredNotes = _allNotes.where((note) => note.isFree == _showFree);

    emit(
      StudyNotesDataSuccess(
        notes: List<StudyNoteEntity>.unmodifiable(filteredNotes),
        showFree: _showFree,
        hasValidSubscription: _hasValidSubscription,
        subscriptionError: _subscriptionError,
      ),
    );
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    _emitFailure(FirebaseErrorHandler.handle(error));
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

    try {
      await _cancelSubscription();
    } finally {
      await super.close();
    }
  }
}
