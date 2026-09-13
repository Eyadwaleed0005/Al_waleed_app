import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_question_entity.dart';

class StudentExamQuestionModel extends StudentExamQuestionEntity {
  const StudentExamQuestionModel({
    required super.questionId,
    required super.examId,
    required super.questionText,
    required super.choices,
    required super.degree,
    required super.questionOrder,
    super.questionImageUrl,
  });

  factory StudentExamQuestionModel.fromMap(Map<String, dynamic> data) {
    ExamRemoteResponseValidator.ensureQuestionIsSafe(data);

    final List<String> choices = _readChoices(data);

    final int degree = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.questionScore],
    );

    final int questionOrder = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.questionOrder],
    );

    ExamRemoteResponseValidator.ensurePositive(degree);

    ExamRemoteResponseValidator.ensureNotNegative(questionOrder);

    return StudentExamQuestionModel(
      questionId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.questionId],
      ),
      examId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.examId],
      ),
      questionText: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.questionText],
      ),
      questionImageUrl: ExamRemoteResponseValidator.readNullableString(
        data[FirestoreFields.questionImageUrl],
      ),
      choices: List<String>.unmodifiable(choices),
      degree: degree,
      questionOrder: questionOrder,
    );
  }

  StudentExamQuestionEntity toEntity() {
    return StudentExamQuestionEntity(
      questionId: questionId,
      examId: examId,
      questionText: questionText,
      questionImageUrl: questionImageUrl,
      choices: choices,
      degree: degree,
      questionOrder: questionOrder,
    );
  }

  static List<String> _readChoices(Map<String, dynamic> data) {
    final dynamic rawChoices = data[FirestoreFields.choices];

    final List<String> choices;

    if (rawChoices is List) {
      choices = rawChoices
          .map((dynamic choice) {
            return ExamRemoteResponseValidator.readRequiredString(choice);
          })
          .toList(growable: false);
    } else {
      choices = <String>[
        ExamRemoteResponseValidator.readRequiredString(
          data[FirestoreFields.option1],
        ),
        ExamRemoteResponseValidator.readRequiredString(
          data[FirestoreFields.option2],
        ),
        ExamRemoteResponseValidator.readRequiredString(
          data[FirestoreFields.option3],
        ),
        ExamRemoteResponseValidator.readRequiredString(
          data[FirestoreFields.option4],
        ),
      ];
    }

    if (choices.length != 4) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    return choices;
  }
}
