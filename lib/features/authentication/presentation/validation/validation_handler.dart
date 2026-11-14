enum ValidationField {
  name,
  email,
  phoneNumber,
  grade,
  password,
  confirmPassword,
}

class ValidationRequest {
  const ValidationRequest({
    required this.field,
    required this.value,
    this.password,
  });

  final ValidationField field;
  final String value;
  final String? password;
}

abstract class ValidationHandler {
  ValidationHandler? _nextHandler;

  ValidationHandler setNext(ValidationHandler handler) {
    _nextHandler = handler;
    return handler;
  }

  String? handle(ValidationRequest request) {
    return _nextHandler?.handle(request);
  }
}
