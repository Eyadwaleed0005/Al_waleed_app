import 'package:al_waleed/features/authentication/data/models/login_model.dart';


 abstract class LoginRemoteDataSource {
  Future<LoginModel> login({required String email, required String password});
}

