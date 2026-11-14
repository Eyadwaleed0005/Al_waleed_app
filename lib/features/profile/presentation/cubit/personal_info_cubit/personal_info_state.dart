part of 'personal_info_cubit.dart';

enum PersonalInfoStatus {
  initial,
  loading,
  ready,
  saving,
  saved,
  loadFailure,
  saveFailure,
}

class PersonalInfoState extends Equatable {
  const PersonalInfoState({
    this.status = PersonalInfoStatus.initial,
    this.personalInfo,
    this.name = '',
    this.phoneNumber = '',
    this.email = '',
    this.error,
  });

  final PersonalInfoStatus status;
  final PersonalInfoEntity? personalInfo;
  final String name;
  final String phoneNumber;
  final String email;
  final AppErrorModel? error;

  bool get hasChanges {
    final original = personalInfo;

    if (original == null) return false;

    return name.trim() != original.name.trim() ||
        phoneNumber.trim() != original.phoneNumber.trim() ||
        email.trim().toLowerCase() != original.email.trim().toLowerCase();
  }

  bool get isSaving => status == PersonalInfoStatus.saving;

  bool get canSave {
    return personalInfo != null &&
        status != PersonalInfoStatus.loading &&
        !isSaving &&
        hasChanges;
  }

  PersonalInfoState copyWith({
    PersonalInfoStatus? status,
    PersonalInfoEntity? personalInfo,
    String? name,
    String? phoneNumber,
    String? email,
    AppErrorModel? error,
    bool clearError = false,
  }) {
    return PersonalInfoState(
      status: status ?? this.status,
      personalInfo: personalInfo ?? this.personalInfo,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    personalInfo,
    name,
    phoneNumber,
    email,
    error,
  ];
}
