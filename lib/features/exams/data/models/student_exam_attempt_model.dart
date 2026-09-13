import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/student_exam_attempt_response_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExamAttemptModel extends StudentExamAttemptEntity {
  const StudentExamAttemptModel({
    required super.resultId,
    required super.examId,
    required super.studentId,
    required super.status,
    required super.totalScore,
    required super.startedAt,
    required super.expiresAt,
    super.score,
    super.submittedAt,
  });

  factory StudentExamAttemptModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return StudentExamAttemptModel.fromMap(
      data: document.data() ?? <String, dynamic>{},
      fallbackResultId: document.id,
    );
  }

  factory StudentExamAttemptModel.fromMap({
    required Map<String, dynamic> data,
    String? fallbackResultId,
  }) {
    final int? score = ExamRemoteResponseValidator.readNullableInt(
      data[FirestoreFields.score] ?? data[FirestoreFields.studentScore],
    );

    final int totalScore = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.totalScore],
    );

    final DateTime? submittedAt = ExamRemoteResponseValidator.readDateTime(
      data[FirestoreFields.submittedAt],
    );

    final DateTime startedAt = ExamRemoteResponseValidator.readRequiredDateTime(
      data[FirestoreFields.startedAt],
    );

    final DateTime expiresAt = ExamRemoteResponseValidator.readRequiredDateTime(
      data[FirestoreFields.expiresAt],
    );

    ExamRemoteResponseValidator.ensurePositive(totalScore);

    if (!expiresAt.isAfter(startedAt)) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    if (score != null) {
      ExamRemoteResponseValidator.ensureNotNegative(score);

      if (score > totalScore) {
        FirebaseErrorHandler.throwFirestoreCode('data-loss');
      }
    }

    return StudentExamAttemptModel(
      resultId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.resultId] ?? fallbackResultId,
      ),
      examId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.examId],
      ),
      studentId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.studentId],
      ),
      status: StudentExamAttemptResponseValidator.readStatus(
        value:
            data[FirestoreFields.status] ?? data[FirestoreFields.resultStatus],
        score: score,
        submittedAt: submittedAt,
      ),
      score: score,
      totalScore: totalScore,
      startedAt: startedAt,
      expiresAt: expiresAt,
      submittedAt: submittedAt,
    );
  }

  StudentExamAttemptEntity toEntity() {
    return StudentExamAttemptEntity(
      resultId: resultId,
      examId: examId,
      studentId: studentId,
      status: status,
      totalScore: totalScore,
      startedAt: startedAt,
      expiresAt: expiresAt,
      score: score,
      submittedAt: submittedAt,
    );
  }
}
