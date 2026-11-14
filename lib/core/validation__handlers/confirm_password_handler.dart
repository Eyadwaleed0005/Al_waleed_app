import 'package:al_waleed/features/authentication/presentation/validation/validation_handler.dart';

class ConfirmPasswordHandler extends ValidationHandler {
  @override
  String? handle(ValidationRequest request) {
    if (request.field != ValidationField.confirmPassword) {
      return super.handle(request);
    }

    if (request.value.isEmpty) {
      return 'من فضلك أعد كتابة كلمة المرور';
    }

    if (request.value != request.password) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return super.handle(request);
  }
}
