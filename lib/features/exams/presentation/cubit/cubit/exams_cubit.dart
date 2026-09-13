import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'exams_state.dart';

class ExamsCubit extends Cubit<ExamsState> {
  ExamsCubit() : super(ExamsInitial());
}
