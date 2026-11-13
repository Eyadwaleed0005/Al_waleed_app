import '../validation_handler.dart';

class EmailHandler extends ValidationHandler {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@'
    r'[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  String? handle(ValidationRequest request) {
    if (request.field != ValidationField.email) {
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
