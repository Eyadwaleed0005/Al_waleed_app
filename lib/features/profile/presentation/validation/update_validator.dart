import 'package:al_waleed/core/validation__handlers/email_handler.dart';
import 'package:al_waleed/core/validation__handlers/name_handler.dart';
import 'package:al_waleed/core/validation__handlers/phone_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/validation_handler.dart';

class UpdateValidator {
  UpdateValidator._();

  static final ValidationHandler _chain = _createChain();

  static ValidationHandler _createChain() {
    final nameHandler = NameHandler();
    final phoneHandler = PhoneHandler();
    final emailHandler = EmailHandler();

    nameHandler.setNext(phoneHandler).setNext(emailHandler);

    return nameHandler;
  }

  static String? name(String? value) {
    return _chain.handle(
      ValidationRequest(field: ValidationField.name, value: value ?? ''),
    );
  }

  static String? phoneNumber(String? value) {
    return _chain.handle(
      ValidationRequest(field: ValidationField.phoneNumber, value: value ?? ''),
    );
  }

  static String? email(String? value) {
    return _chain.handle(
      ValidationRequest(field: ValidationField.email, value: value ?? ''),
    );
  }
}
