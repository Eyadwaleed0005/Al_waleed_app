import 'package:al_waleed/features/authentication/presentation/validation/login_validation_handler.dart';

class EmailHandler extends LoginValidationHandler {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@'
    r'[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  String? handle(LoginValidationRequest request) {
    if (request.field != LoginValidationField.email) {
      return super.handle(request);
    }

    final email = request.value.trim();

    if (email.isEmpty) {
      return 'من فضلك اكتب البريد الإلكتروني';
    }

    if (!_emailRegExp.hasMatch(email)) {
      return 'من فضلك اكتب بريدًا إلكترونيًا صحيحًا';
    }

    return super.handle(request);
  }
}