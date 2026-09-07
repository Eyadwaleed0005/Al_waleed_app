// the chain
import 'package:al_waleed/features/authentication/presentation/validation/email_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/login_validation_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/password_handler.dart';

class LoginValidation {
  LoginValidation._();

  static final LoginValidationHandler _chain = _createChain();

  static LoginValidationHandler _createChain() {
    final emailHandler = EmailHandler();
    final passwordHandler = PasswordHandler();

    emailHandler.setNext(passwordHandler);

    return emailHandler;
  }

  static String? email(String? value) {
    return _chain.handle(
      LoginValidationRequest(
        field: LoginValidationField.email,
        value: value ?? '',
      ),
    );
  }

  static String? password(String? value) {
    return _chain.handle(
      LoginValidationRequest(
        field: LoginValidationField.password,
        value: value ?? '',
      ),
    );
  }
}