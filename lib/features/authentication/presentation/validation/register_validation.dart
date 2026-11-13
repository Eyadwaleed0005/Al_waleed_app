import 'package:al_waleed/features/authentication/presentation/validation/validation__handlers/confirm_password_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/validation__handlers/email_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/validation__handlers/grade_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/validation__handlers/name_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/validation__handlers/password_handler.dart';
import 'package:al_waleed/features/authentication/presentation/validation/validation__handlers/phone_handler.dart';
import 'validation_handler.dart';

class RegisterValidation {
  RegisterValidation._();

  static final ValidationHandler _chain = _createChain();

  static ValidationHandler _createChain() {
    final nameHandler = NameHandler();
    final emailHandler = EmailHandler();
    final phoneHandler = PhoneHandler();
    final gradeHandler = GradeHandler();
    final passwordHandler = PasswordHandler(requireStrongPassword: true);
    final confirmPasswordHandler = ConfirmPasswordHandler();

    nameHandler
        .setNext(emailHandler)
        .setNext(phoneHandler)
        .setNext(gradeHandler)
        .setNext(passwordHandler)
        .setNext(confirmPasswordHandler);

    return nameHandler;
  }

  static String? name(String? value) {
    return _validate(ValidationField.name, value);
  }

  static String? email(String? value) {
    return _validate(ValidationField.email, value);
  }

  static String? phoneNumber(String? value) {
    return _validate(ValidationField.phoneNumber, value);
  }

  static String? grade(String? value) {
    return _validate(ValidationField.grade, value);
  }

  static String? password(String? value) {
    return _validate(ValidationField.password, value);
  }

  static String? confirmPassword(String? value, String password) {
    return _chain.handle(
      ValidationRequest(
        field: ValidationField.confirmPassword,
        value: value ?? '',
        password: password,
      ),
    );
  }

  static String? _validate(ValidationField field, String? value) {
    return _chain.handle(ValidationRequest(field: field, value: value ?? ''));
  }
}
