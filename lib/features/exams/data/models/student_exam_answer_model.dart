import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_identifier_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_answer_entity.dart';

class StudentExamAnswerModel extends StudentExamAnswerEntity {
  const StudentExamAnswerModel({
    required super.questionId,
    required super.selectedChoiceIndex,
  });

  factory StudentExamAnswerModel.fromEntity(StudentExamAnswerEntity entity) {
    return StudentExamAnswerModel(
      questionId: entity.questionId,
      selectedChoiceIndex: entity.selectedChoiceIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.questionId: ExamRemoteIdentifierValidator.validate(
        questionId,
      ),
      FirestoreFields.selectedChoiceIndex: selectedChoiceIndex,
    };
  }
}
