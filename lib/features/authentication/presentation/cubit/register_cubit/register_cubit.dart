import 'package:al_waleed/features/authentication/domain/entity/register_entity.dart';
import 'package:al_waleed/features/authentication/domain/usecase/register_student_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.registerStudentUseCase})
    : super(const RegisterInitial());

  final RegisterStudentUseCase registerStudentUseCase;

  Future<void> register({
    required String name,
    required String gradeId,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    if (isClosed || state is RegisterLoading || state is RegisterSuccess) {
      return;
    }

    emit(const RegisterLoading());

    final result = await registerStudentUseCase(
      name: name,
      gradeId: gradeId,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(RegisterFailure(errorMessage: failure.message)),
      (student) => emit(RegisterSuccess(registerEntity: student)),
    );
  }
}
