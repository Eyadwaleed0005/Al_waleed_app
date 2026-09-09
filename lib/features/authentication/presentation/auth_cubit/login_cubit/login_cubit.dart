import 'package:al_waleed/features/authentication/domain/entity/login_entity.dart';
import 'package:al_waleed/features/authentication/domain/usecase/login_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginUseCase}) : super(LoginInitial());
  final LoginUseCase loginUseCase;
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    final result = await loginUseCase.login(email: email, password: password);
    result.fold(
      (fail) => emit(LoginFailure(errorMessage: fail.message)),
      (user) => emit(LoginSuccess(loginEntity: user)),
    );
  }
}
