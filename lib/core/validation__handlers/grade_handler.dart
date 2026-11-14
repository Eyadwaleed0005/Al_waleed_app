import 'package:al_waleed/features/authentication/presentation/validation/validation_handler.dart';

class GradeHandler extends ValidationHandler {
  @override
  String? handle(ValidationRequest request) {
    if (request.field != ValidationField.grade) {
      return super.handle(request);
    }

    if (request.value.trim().isEmpty) {
      return 'من فضلك اختر الصف الدراسي';
    }

    return super.handle(request);
  }
}
