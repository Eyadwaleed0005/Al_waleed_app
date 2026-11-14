import 'package:al_waleed/features/profile/domain/usecase/delete_account_use_case.dart';
import 'package:al_waleed/features/profile/presentation/cubit/delete_account_cubit/delete_account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit({required DeleteAccountUseCase deleteAccountUseCase})
    : _deleteAccountUseCase = deleteAccountUseCase,
      super(const DeleteAccountInitial());

  final DeleteAccountUseCase _deleteAccountUseCase;

  bool _isDeleting = false;

  Future<void> deleteAccount({required String currentPassword}) async {
    if (isClosed || _isDeleting || state is DeleteAccountSuccess) {
      return;
    }

    _isDeleting = true;

    try {
      emit(const DeleteAccountLoading());

      final result = await _deleteAccountUseCase(
        currentPassword: currentPassword,
      );

      if (isClosed) return;

      result.fold(
        (error) {
          emit(DeleteAccountFailure(error: error));
        },
        (_) {
          emit(const DeleteAccountSuccess());
        },
      );
    } finally {
      _isDeleting = false;
    }
  }
}
