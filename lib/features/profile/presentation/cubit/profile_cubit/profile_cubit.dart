import 'dart:async';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/domain/usecase/stream_student_profile_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final StreamStudentProfileUseCase _streamStudentProfileUseCase;

  ProfileCubit({
    required StreamStudentProfileUseCase streamStudentProfileUseCase,
  }) : _streamStudentProfileUseCase = streamStudentProfileUseCase,
       super(const ProfileInitial());

  StreamSubscription<Either<AppErrorModel, ProfileEntity>>?
  _profileSubscription;

  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitializing || isClosed) return;

    _isInitializing = true;

    try {
      await _cancelProfileSubscription();

      if (isClosed) return;

      emit(const ProfileLoading());

      _profileSubscription = _streamStudentProfileUseCase().listen(
        _onProfileResult,
      );
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void _onProfileResult(Either<AppErrorModel, ProfileEntity> result) {
    if (isClosed) return;

    result.fold(_emitFailure, _emitSuccess);
  }

  void _emitSuccess(ProfileEntity profile) {
    if (isClosed) return;

    emit(ProfileSuccess(profile: profile));
  }

  void _emitFailure(AppErrorModel error) {
    if (isClosed) return;

    emit(ProfileFailure(error: error));
  }

  Future<void> _cancelProfileSubscription() async {
    await _profileSubscription?.cancel();
    _profileSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelProfileSubscription();

    return super.close();
  }
}
