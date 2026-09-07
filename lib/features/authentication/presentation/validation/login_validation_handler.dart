// Applies the Chain of Responsibility pattern to login field validation.
enum LoginValidationField {
  email,
  password,
}

class LoginValidationRequest {
  final LoginValidationField field;
  final String value;

  const LoginValidationRequest({
    required this.field,
    required this.value,
  });
}

abstract class LoginValidationHandler {
  LoginValidationHandler? _nextHandler;

  LoginValidationHandler setNext(LoginValidationHandler handler) {
    _nextHandler = handler;
    return handler;
  }

  String? handle(LoginValidationRequest request) {
    return _nextHandler?.handle(request);
  }
}