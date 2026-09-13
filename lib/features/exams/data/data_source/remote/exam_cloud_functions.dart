abstract final class ExamCloudFunctions {
  const ExamCloudFunctions._();

  static const String startExamAttempt = 'startExamAttempt';

  static const String getStudentExam = 'getStudentExam';

  static const String submitExamAttempt = 'submitExamAttempt';
}

abstract final class ExamCloudFunctionFields {
  const ExamCloudFunctionFields._();

  static const String exam = 'exam';

  static const String attempt = 'attempt';

  static const String result = 'result';

  static const String questions = 'questions';

  static const String answers = 'answers';

  static const String isAutomatic = 'isAutomatic';
}
