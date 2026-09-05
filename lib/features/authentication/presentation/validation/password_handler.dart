import 'package:al_waleed/features/authentication/presentation/validation/login_validation_handler.dart';

class PasswordHandler extends LoginValidationHandler {
  @override
  String? handle(LoginValidationRequest request) {
    if (request.field != LoginValidationField.password) {
      return super.handle(request);
    }

    if (request.value.isEmpty) {
      return 'من فضلك اكتب كلمة المرور';
    }

    return super.handle(request);
  }
}