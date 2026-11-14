import 'package:al_waleed/features/authentication/data/models/register_model.dart';

abstract interface class RegisterRemoteDataSource {
  Future<RegisterModel> registerStudent({
    required String name,
    required String gradeId,
    required String email,
    required String phoneNumber,
    required String password,
  });
}
