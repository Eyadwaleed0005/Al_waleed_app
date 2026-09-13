import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/student_exam_result_response_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';

class StudentExamResultModel extends StudentExamResultEntity {
  const StudentExamResultModel({
    required super.resultId,
    required super.examId,
    required super.examName,
    required super.score,
    required super.totalScore,
    required super.correctAnswers,
    required super.wrongAnswers,
    required super.unansweredQuestions,
    required super.submittedAt,
  });

  factory StudentExamResultModel.fromMap(Map<String, dynamic> data) {
    final int score = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.score] ?? data[FirestoreFields.studentScore],
    );

    final int totalScore = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.totalScore],
    );

    final int correctAnswers = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.correctAnswers],
    );

    final int wrongAnswers = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.wrongAnswers],
    );

    final int unansweredQuestions = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.unansweredQuestions],
    );

    StudentExamResultResponseValidator.validate(
      score: score,
      totalScore: totalScore,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      unansweredQuestions: unansweredQuestions,
    );

    return StudentExamResultModel(
      resultId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.resultId],
      ),
      examId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.examId],
      ),
      examName: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.examName],
      ),
      score: score,
      totalScore: totalScore,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      unansweredQuestions: unansweredQuestions,
      submittedAt: ExamRemoteResponseValidator.readRequiredDateTime(
        data[FirestoreFields.submittedAt],
      ),
    );
  }

  StudentExamResultEntity toEntity() {
    return StudentExamResultEntity(
      resultId: resultId,
      examId: examId,
      examName: examName,
      score: score,
      totalScore: totalScore,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      unansweredQuestions: unansweredQuestions,
      submittedAt: submittedAt,
    );
  }
}
