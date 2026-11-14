import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/profile/domain/entities/personal_info_entity.dart';
import 'package:al_waleed/features/profile/domain/usecase/get_personal_info_use_case.dart';
import 'package:al_waleed/features/profile/domain/usecase/update_personal_info_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit({
    required GetPersonalInfoUseCase getPersonalInfoUseCase,
    required UpdatePersonalInfoUseCase updatePersonalInfoUseCase,
  }) : _getPersonalInfoUseCase = getPersonalInfoUseCase,
       _updatePersonalInfoUseCase = updatePersonalInfoUseCase,
       super(const PersonalInfoState());

  final GetPersonalInfoUseCase _getPersonalInfoUseCase;
  final UpdatePersonalInfoUseCase _updatePersonalInfoUseCase;

  Future<void> initialize() async {
    if (isClosed ||
        state.status == PersonalInfoStatus.loading ||
        state.isSaving) {
      return;
    }

    emit(const PersonalInfoState(status: PersonalInfoStatus.loading));

    final result = await _getPersonalInfoUseCase();

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          PersonalInfoState(
            status: PersonalInfoStatus.loadFailure,
            error: error,
          ),
        );
      },
      (personalInfo) {
        emit(
          PersonalInfoState(
            status: PersonalInfoStatus.ready,
            personalInfo: personalInfo,
            name: personalInfo.name,
            phoneNumber: personalInfo.phoneNumber,
            email: personalInfo.email,
          ),
        );
      },
    );
  }

  Future<void> retry() {
    return initialize();
  }

  bool get _canEdit {
    return !isClosed &&
        state.personalInfo != null &&
        !state.isSaving &&
        state.status != PersonalInfoStatus.loading;
  }

  void nameChanged(String value) {
    if (!_canEdit || value == state.name) return;

    emit(
      state.copyWith(
        status: PersonalInfoStatus.ready,
        name: value,
        clearError: true,
      ),
    );
  }

  void phoneNumberChanged(String value) {
    if (!_canEdit || value == state.phoneNumber) return;

    emit(
      state.copyWith(
        status: PersonalInfoStatus.ready,
        phoneNumber: value,
        clearError: true,
      ),
    );
  }

  void emailChanged(String value) {
    if (!_canEdit || value == state.email) return;

    emit(
      state.copyWith(
        status: PersonalInfoStatus.ready,
        email: value,
        clearError: true,
      ),
    );
  }

  Future<void> save({String? currentPassword}) async {
    if (isClosed || !state.canSave) return;

    final original = state.personalInfo!;

    final name = state.name.trim();
    final phoneNumber = state.phoneNumber.trim();
    final email = state.email.trim().toLowerCase();

    final hasEmailChanged = email != original.email.trim().toLowerCase();

    emit(state.copyWith(status: PersonalInfoStatus.saving, clearError: true));

    final result = await _updatePersonalInfoUseCase(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      currentPassword: hasEmailChanged ? currentPassword : null,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          state.copyWith(status: PersonalInfoStatus.saveFailure, error: error),
        );
      },
      (_) {
        final updatedInfo = PersonalInfoEntity(
          studentId: original.studentId,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
        );

        emit(
          PersonalInfoState(
            status: PersonalInfoStatus.saved,
            personalInfo: updatedInfo,
            name: updatedInfo.name,
            phoneNumber: updatedInfo.phoneNumber,
            email: updatedInfo.email,
          ),
        );
      },
    );
  }
}
