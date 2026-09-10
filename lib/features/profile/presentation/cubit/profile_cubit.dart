import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/shared_preferences/shared_preferences.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/domain/usecase/get_student_profile_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getStudentProfileUseCase;
  ProfileCubit({required this.getStudentProfileUseCase})
    : super(LogoutInitial());

  Future<void> getStudentProfile() async {
    emit(GetProfileLoading());

    final result = await getStudentProfileUseCase.call();
    result.fold(
      (failure) {
        emit(GetProfileFailure(errorMsg: failure.message));
      },
      (profile) {
        emit(GetProfileSuccess(profile: profile));
      },
    );
  }

  Future<void> logout() async {
    final ProfileEntity? profile = switch (state) {
      GetProfileSuccess s => s.profile,
      LogoutFailure s => s.profile,
      _ => null,
    };
    if (profile == null) {
      return;
    }

    emit(LogoutLoading(profile: profile));
    try {
      await SecureStorageHelper.clearAll();
      await SharedPreferencesHelper.clearAll();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.students)
            .doc(uid)
            .update({FirestoreFields.isLoggedIn: false});
      }

      await FirebaseAuth.instance.signOut();
      if (!isClosed) {
        emit(LogoutSuccess());
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          LogoutFailure(errorMsg: e.toString(), profile: profile),
        );
      }
    }
  }
}
