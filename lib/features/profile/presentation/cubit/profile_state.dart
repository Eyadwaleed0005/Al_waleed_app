part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileSuccess({
    required this.profile,
  });
}

final class ProfileFailure extends ProfileState {
  final AppErrorModel error;

  const ProfileFailure({
    required this.error,
  });
}