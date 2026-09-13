import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/exam_cloud_functions.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_identifier_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_submission_validator.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_answer_model.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';

class SubmitStudentExamModel extends SubmitStudentExamEntity {
  const SubmitStudentExamModel({
    required super.examId,
    required super.resultId,
    required super.answers,
    required super.isAutomatic,
  });

  factory SubmitStudentExamModel.fromEntity(SubmitStudentExamEntity entity) {
    return SubmitStudentExamModel(
      examId: entity.examId,
      resultId: entity.resultId,
      answers: entity.answers,
      isAutomatic: entity.isAutomatic,
    );
  }

  Map<String, dynamic> toMap() {
    ExamSubmissionValidator.validate(this);

    return <String, dynamic>{
      FirestoreFields.examId: ExamRemoteIdentifierValidator.validate(examId),
      FirestoreFields.resultId: ExamRemoteIdentifierValidator.validate(
        resultId,
      ),
      ExamCloudFunctionFields.answers: answers
          .map((answer) {
            return StudentExamAnswerModel.fromEntity(answer).toMap();
          })
          .toList(growable: false),
      ExamCloudFunctionFields.isAutomatic: isAutomatic,
    };
  }
}
