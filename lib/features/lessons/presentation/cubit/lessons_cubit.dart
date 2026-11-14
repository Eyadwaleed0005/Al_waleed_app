import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/domain/use_case/check_lesson_access_use_case.dart';
import 'package:al_waleed/features/lessons/domain/use_case/stream_lessons_use_case.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lessons_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsCubit extends Cubit<LessonsState> {
  LessonsCubit({
    required StreamLessonsUseCase streamLessonsUseCase,
    required CheckLessonAccessUseCase checkLessonAccessUseCase,
  }) : _streamLessonsUseCase = streamLessonsUseCase,
       _checkLessonAccessUseCase = checkLessonAccessUseCase,
       super(const LessonsInitial());

  final StreamLessonsUseCase _streamLessonsUseCase;
  final CheckLessonAccessUseCase _checkLessonAccessUseCase;

  StreamSubscription<Either<AppErrorModel, List<LessonEntity>>>?
  _lessonsSubscription;

  bool _isInitializing = false;
  bool _isClosing = false;
  bool _showFree = true;
  bool? _hasValidSubscription;

  List<LessonEntity> _allLessons = const <LessonEntity>[];

  String _query = '';

  String get query => _query;

  bool get showFree => _showFree;

  bool get _canEmit => !_isClosing && !isClosed;

  Future<void> initialize() async {
    if (_isInitializing || !_canEmit) return;

    _isInitializing = true;

    try {
      await _cancelSubscription();

      if (!_canEmit) return;

      _allLessons = const <LessonEntity>[];
      _query = '';
      _showFree = true;
      _hasValidSubscription = null;

      emit(const LessonsLoading());

      final subscriptionResult = await _checkLessonAccessUseCase
          .checkSubscription();

      if (!_canEmit) return;

      _hasValidSubscription = subscriptionResult.fold<bool?>(
        (_) => null,
        (isActive) => isActive,
      );

      _watchLessons();
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void selectAccessType(bool showFree) {
    if (!_canEmit || state is! LessonsDataSuccess) return;

    if (_showFree == showFree) return;

    _showFree = showFree;

    _emitFilteredLessons();
  }

  void search(String query) {
    if (!_canEmit || state is! LessonsDataSuccess) return;

    final normalizedQuery = query.trim();

    if (normalizedQuery == _query) return;

    _query = normalizedQuery;

    _emitFilteredLessons();
  }

  Future<Either<AppErrorModel, bool>> checkLessonAccess({
    required LessonEntity lesson,
  }) async {
    final result = await _checkLessonAccessUseCase(lesson: lesson);

    if (!_canEmit || lesson.isFree) {
      return result;
    }

    result.fold((_) {}, (isActive) {
      _hasValidSubscription = isActive;

      if (state is LessonsDataSuccess) {
        _emitFilteredLessons();
      }
    });

    return result;
  }

  void _watchLessons() {
    if (!_canEmit) return;

    _lessonsSubscription = _streamLessonsUseCase().listen(_onLessonsResult);
  }

  void _onLessonsResult(Either<AppErrorModel, List<LessonEntity>> result) {
    if (!_canEmit) return;

    result.fold(_emitFailure, _emitLessons);
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

    final filtered = _allLessons
        .where((lesson) {
          final matchesAccessType = lesson.isFree == _showFree;
          final matchesSearch = _query.isEmpty || _matchesQuery(lesson);

          return matchesAccessType && matchesSearch;
        })
        .toList(growable: false);

    emit(
      LessonsDataSuccess(
        lessons: List<LessonEntity>.unmodifiable(filtered),
        query: _query,
        showFree: _showFree,
        hasValidSubscription: _hasValidSubscription,
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
