import 'package:al_waleed/core/cache/errors/local_storage_error_handler.dart';
import 'package:al_waleed/features/exams/data/data_source/cache/validation/exam_attempt_identifier_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/cached_exam_attempt_entity.dart';

abstract final class ExamAttemptAnswerValidator {
  const ExamAttemptAnswerValidator._();

  static void validateAnswerEditing({
    required CachedExamAttemptEntity attempt,
    required String questionId,
    required int? selectedChoiceIndex,
  }) {
    final String normalizedQuestionId = ExamAttemptIdentifierValidator.validate(
      questionId,
    );

    validateOptionalChoiceIndex(selectedChoiceIndex);

    if (attempt.isTimeExpired || attempt.isPendingSubmission) {
      LocalStorageErrorHandler.throwOperationNotAllowed();
    }

    if (!attempt.questionIds.contains(normalizedQuestionId)) {
      LocalStorageErrorHandler.throwInvalidData();
    }
  }

  static void validateOptionalChoiceIndex(int? selectedChoiceIndex) {
    if (selectedChoiceIndex == null) {
      return;
    }

    validateRequiredChoiceIndex(selectedChoiceIndex);
  }

  static void validateRequiredChoiceIndex(int selectedChoiceIndex) {
    if (selectedChoiceIndex < 0 || selectedChoiceIndex > 3) {
      LocalStorageErrorHandler.throwInvalidData();
    }
  }
}
