import 'package:al_waleed/features/authentication/presentation/validation/validation_handler.dart';

class PhoneHandler extends ValidationHandler {
  static final RegExp _digitsRegExp = RegExp(r'^\d+$');

  @override
  String? handle(ValidationRequest request) {
    if (request.field != ValidationField.phoneNumber) {
      return super.handle(request);
    }

    final phone = request.value.trim();

    if (phone.isEmpty) {
      return 'من فضلك اكتب رقم الهاتف';
    }

    if (!_digitsRegExp.hasMatch(phone)) {
      return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
    }

    if (phone.length != 11) {
      return 'رقم الهاتف يجب أن يتكون من 11 رقمًا';
    }

    if (!phone.startsWith('01')) {
      return 'رقم الهاتف يجب أن يبدأ بـ 01';
    }

    return super.handle(request);
  }
}
