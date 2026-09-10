
import 'package:al_waleed/features/authentication/domain/entity/login_entity.dart';

class LoginModel  extends LoginEntity{
  final String id;


  LoginModel({
    required this.id,
    required super.email,
 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
   
      'email': email,

    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      id: map['id'] ?? '',

      email: map['email'] ?? '',
   
    );
  }
}
