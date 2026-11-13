import '../validation_handler.dart';

class PasswordHandler extends ValidationHandler {
  PasswordHandler({this.requireStrongPassword = false});

  final bool requireStrongPassword;

  static final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegExp = RegExp(r'[a-z]');
  static final RegExp _numberRegExp = RegExp(r'[0-9]');
  static final RegExp _specialCharacterRegExp = RegExp(
    r'[!@#$%^&*(),.?":{}|<>]',
  );

  @override
  String? handle(ValidationRequest request) {
    if (request.field != ValidationField.password) {
      return super.handle(request);
    }

    final password = request.value;

    if (password.isEmpty) {
      return 'من فضلك اكتب كلمة المرور';
    }

    if (!requireStrongPassword) {
      return super.handle(request);
    }

    if (password.length < 8) {
      return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
    }

    if (password.contains(' ')) {
      return 'كلمة المرور لا يجب أن تحتوي على مسافات';
    }

    if (!_uppercaseRegExp.hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير';
    }

    if (!_lowercaseRegExp.hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير';
    }

    if (!_numberRegExp.hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على رقم';
    }

    if (!_specialCharacterRegExp.hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص';
    }

    return super.handle(request);
  }
}
