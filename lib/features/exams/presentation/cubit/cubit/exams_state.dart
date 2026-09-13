part of 'exams_cubit.dart';

sealed class ExamsState extends Equatable {
  const ExamsState();

  @override
  List<Object> get props => [];
}

final class ExamsInitial extends ExamsState {}
