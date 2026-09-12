import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/use_case/stream_lessons_use_case.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lessons_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final StreamLessonsUseCase _streamLessonsUseCase;

  LessonsCubit({
    required StreamLessonsUseCase streamLessonsUseCase,
  }) : _streamLessonsUseCase = streamLessonsUseCase,
       super(const LessonsInitial());

  StreamSubscription<Either<AppErrorModel, List<LessonEntity>>>?
  _lessonsSubscription;

  bool _isInitializing = false;
  bool _isClosing = false;

  List<LessonEntity> _allLessons = const <LessonEntity>[];

  String _query = '';

  String get query => _query;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> initialize() async {
    if (_isInitializing || !_canEmit) return;

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (!_canEmit) return;

      _allLessons = const <LessonEntity>[];
      _query = '';

      emit(const LessonsLoading());

      if (!_canEmit) return;

      _watchLessons();
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void _watchLessons() {
    if (!_canEmit) return;

    _lessonsSubscription = _streamLessonsUseCase().listen(
      _onLessonsResult,
    );
  }

  void _onLessonsResult(
    Either<AppErrorModel, List<LessonEntity>> result,
  ) {
    if (!_canEmit) return;

    result.fold(_emitFailure, _emitLessons);
  }

  void search(String query) {
    if (!_canEmit) return;

    final normalizedQuery = query.trim();
    if (normalizedQuery == _query) return;

    _query = normalizedQuery;

    _emitFilteredLessons();
  }

  void _emitLessons(List<LessonEntity> lessons) {
    if (!_canEmit) return;

    _allLessons = List<LessonEntity>.unmodifiable(lessons);

    if (_allLessons.isEmpty) {
      emit(const LessonsEmpty());
      return;
    }

    _emitFilteredLessons();
  }

  void _emitFilteredLessons() {
    if (!_canEmit) return;

    final filtered = _query.isEmpty
        ? _allLessons
        : _allLessons.where(_matchesQuery).toList(growable: false);

    emit(
      LessonsDataSuccess(
        lessons: List<LessonEntity>.unmodifiable(filtered),
        query: _query,
      ),
    );
  }

  bool _matchesQuery(LessonEntity lesson) {
    final query = _query.toLowerCase();

    return lesson.title.toLowerCase().contains(query) ||
        lesson.description.toLowerCase().contains(query);
  }

  void _emitFailure(AppErrorModel error) {
    if (!_canEmit) return;

    emit(LessonsFailure(error: error));
  }

  Future<void> _cancelSubscription() async {
    final subscription = _lessonsSubscription;
    _lessonsSubscription = null;

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
