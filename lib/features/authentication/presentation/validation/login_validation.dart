import 'package:al_waleed/core/validation__handlers/email_handler.dart';
import 'package:al_waleed/core/validation__handlers/password_handler.dart';
import 'validation_handler.dart';

class LoginValidation {
  LoginValidation._();

  static final ValidationHandler _chain = _createChain();

  static ValidationHandler _createChain() {
    final emailHandler = EmailHandler();
    final passwordHandler = PasswordHandler();

    emailHandler.setNext(passwordHandler);

    return emailHandler;
  }

  static String? email(String? value) {
    return _chain.handle(
      ValidationRequest(field: ValidationField.email, value: value ?? ''),
    );
  }

  static String? password(String? value) {
    return _chain.handle(
      ValidationRequest(field: ValidationField.password, value: value ?? ''),
    );
  }
}
