import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExamModel extends StudentExamEntity {
  const StudentExamModel({
    required super.examId,
    required super.gradeId,
    required super.examName,
    required super.questionCount,
    required super.durationMinutes,
    required super.totalScore,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StudentExamModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return StudentExamModel.fromMap(
      data: document.data() ?? <String, dynamic>{},
      fallbackExamId: document.id,
    );
  }

  factory StudentExamModel.fromMap({
    required Map<String, dynamic> data,
    String? fallbackExamId,
  }) {
    final int questionCount = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.questionCount],
    );

    final int durationMinutes = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.durationMinutes],
    );

    final int totalScore = ExamRemoteResponseValidator.readInt(
      data[FirestoreFields.totalScore],
    );

    ExamRemoteResponseValidator.ensurePositive(questionCount);

    ExamRemoteResponseValidator.ensurePositive(durationMinutes);

    ExamRemoteResponseValidator.ensurePositive(totalScore);

    return StudentExamModel(
      examId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.examId] ?? fallbackExamId,
      ),
      gradeId: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.gradeId],
      ),
      examName: ExamRemoteResponseValidator.readRequiredString(
        data[FirestoreFields.examName],
      ),
      questionCount: questionCount,
      durationMinutes: durationMinutes,
      totalScore: totalScore,
      status: statusFromJson(
        data[FirestoreFields.examStatus] ?? data[FirestoreFields.status],
      ),
      createdAt: ExamRemoteResponseValidator.readRequiredDateTime(
        data[FirestoreFields.createdAt],
      ),
      updatedAt: ExamRemoteResponseValidator.readRequiredDateTime(
        data[FirestoreFields.updatedAt] ?? data[FirestoreFields.createdAt],
      ),
    );
  }

  StudentExamEntity toEntity() {
    return StudentExamEntity(
      examId: examId,
      gradeId: gradeId,
      examName: examName,
      questionCount: questionCount,
      durationMinutes: durationMinutes,
      totalScore: totalScore,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static StudentExamStatus statusFromJson(dynamic value) {
    final String normalizedStatus =
        value?.toString().trim().toLowerCase() ?? '';

    return switch (normalizedStatus) {
      'published' => StudentExamStatus.published,
      'ended' || 'closed' => StudentExamStatus.ended,
      _ => StudentExamStatus.unpublished,
    };
  }
}
