import 'package:al_waleed/features/exams/data/data_source/remote/exam_cloud_functions.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_session_response_validator.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_attempt_model.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_model.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_question_model.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_question_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';

class StudentExamSessionModel extends StudentExamSessionEntity {
  const StudentExamSessionModel({
    required super.exam,
    required super.attempt,
    required super.questions,
  });

  factory StudentExamSessionModel.fromMap(Map<String, dynamic> data) {
    final Map<String, dynamic> examData = ExamRemoteResponseValidator.readMap(
      data[ExamCloudFunctionFields.exam],
    );

    final dynamic rawAttempt =
        data[ExamCloudFunctionFields.attempt] ??
        data[ExamCloudFunctionFields.result];

    final Map<String, dynamic> attemptData =
        ExamRemoteResponseValidator.readMap(rawAttempt);

    final List<dynamic> questionsData = ExamRemoteResponseValidator.readList(
      data[ExamCloudFunctionFields.questions],
    );

    final StudentExamModel exam = StudentExamModel.fromMap(data: examData);

    final StudentExamAttemptModel attempt = StudentExamAttemptModel.fromMap(
      data: attemptData,
    );

    final List<StudentExamQuestionEntity> questions = questionsData
        .map((dynamic questionData) {
          final Map<String, dynamic> questionMap =
              ExamRemoteResponseValidator.readMap(questionData);

          return StudentExamQuestionModel.fromMap(questionMap).toEntity();
        })
        .toList(growable: false);

    questions.sort((first, second) {
      return first.questionOrder.compareTo(second.questionOrder);
    });

    ExamSessionResponseValidator.validate(
      exam: exam,
      attempt: attempt,
      questions: questions,
    );

    return StudentExamSessionModel(
      exam: exam.toEntity(),
      attempt: attempt.toEntity(),
      questions: List<StudentExamQuestionEntity>.unmodifiable(questions),
    );
  }

  StudentExamSessionEntity toEntity() {
    return StudentExamSessionEntity(
      exam: exam,
      attempt: attempt,
      questions: questions,
    );
  }
}
