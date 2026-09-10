import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/shared_preferences/shared_preferences.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
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
        emit(LogoutFailure(errorMsg: e.toString()));
      }
    }
  }
}
