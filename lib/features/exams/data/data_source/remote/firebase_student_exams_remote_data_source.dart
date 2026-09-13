import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/exam_cloud_functions.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/student_exams_remote_data_source.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_identifier_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_remote_response_validator.dart';
import 'package:al_waleed/features/exams/data/data_source/remote/validation/exam_submission_validator.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_attempt_model.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_model.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_result_model.dart';
import 'package:al_waleed/features/exams/data/models/student_exam_session_model.dart';
import 'package:al_waleed/features/exams/data/models/submit_student_exam_model.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_status.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseStudentExamsRemoteDataSource
    implements StudentExamsRemoteDataSource {
  FirebaseStudentExamsRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _functions =
           functions ?? FirebaseFunctions.instanceFor(region: 'us-central1');

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  static const Duration _functionsTimeout = Duration(seconds: 20);

  @override
  Stream<List<StudentExamEntity>> streamGradeExams({required String gradeId}) {
    final String normalizedGradeId = ExamRemoteIdentifierValidator.validate(
      gradeId,
    );

    return FirebaseErrorHandler.executeStream(() {
      return _firestore
          .collection(FirestoreCollections.exams)
          .where(FirestoreFields.gradeId, isEqualTo: normalizedGradeId)
          .where(
            FirestoreFields.examStatus,
            isEqualTo: StudentExamStatus.published.name,
          )
          .where(FirestoreFields.isDeleting, isEqualTo: false)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
            final List<StudentExamEntity> exams = snapshot.docs
                .map((document) {
                  return StudentExamModel.fromFirestore(document).toEntity();
                })
                .toList(growable: false);

            exams.sort((StudentExamEntity first, StudentExamEntity second) {
              return second.createdAt.compareTo(first.createdAt);
            });

            return List<StudentExamEntity>.unmodifiable(exams);
          });
    });
  }

  @override
  Stream<List<StudentExamAttemptEntity>> streamStudentAttempts({
    required String studentId,
  }) {
    final String normalizedStudentId = ExamRemoteIdentifierValidator.validate(
      studentId,
    );

    return FirebaseErrorHandler.executeStream(() {
      return _firestore
          .collection(FirestoreCollections.examResults)
          .where(FirestoreFields.studentId, isEqualTo: normalizedStudentId)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
            final List<StudentExamAttemptEntity> attempts = snapshot.docs
                .map((document) {
                  return StudentExamAttemptModel.fromFirestore(
                    document,
                  ).toEntity();
                })
                .toList(growable: false);

            attempts.sort((
              StudentExamAttemptEntity first,
              StudentExamAttemptEntity second,
            ) {
              return second.startedAt.compareTo(first.startedAt);
            });

            return List<StudentExamAttemptEntity>.unmodifiable(attempts);
          });
    });
  }

  @override
  Future<StudentExamSessionEntity> startExam({required String examId}) {
    final String normalizedExamId = ExamRemoteIdentifierValidator.validate(
      examId,
    );

    return FirebaseErrorHandler.execute(() async {
      final HttpsCallable callable = _functions.httpsCallable(
        ExamCloudFunctions.startExamAttempt,
        options: HttpsCallableOptions(timeout: _functionsTimeout),
      );

      final HttpsCallableResult<dynamic> response = await callable.call(
        <String, dynamic>{FirestoreFields.examId: normalizedExamId},
      );

      final Map<String, dynamic> responseData =
          ExamRemoteResponseValidator.readMap(response.data);

      return StudentExamSessionModel.fromMap(responseData).toEntity();
    }, timeout: _functionsTimeout);
  }

  @override
  Future<StudentExamSessionEntity> resumeExam({
    required String examId,
    required String resultId,
  }) {
    final String normalizedExamId = ExamRemoteIdentifierValidator.validate(
      examId,
    );

    final String normalizedResultId = ExamRemoteIdentifierValidator.validate(
      resultId,
    );

    return FirebaseErrorHandler.execute(() async {
      final HttpsCallable callable = _functions.httpsCallable(
        ExamCloudFunctions.getStudentExam,
        options: HttpsCallableOptions(timeout: _functionsTimeout),
      );

      final HttpsCallableResult<dynamic> response = await callable
          .call(<String, dynamic>{
            FirestoreFields.examId: normalizedExamId,
            FirestoreFields.resultId: normalizedResultId,
          });

      final Map<String, dynamic> responseData =
          ExamRemoteResponseValidator.readMap(response.data);

      return StudentExamSessionModel.fromMap(responseData).toEntity();
    }, timeout: _functionsTimeout);
  }

  @override
  Future<StudentExamResultEntity> submitExam({
    required SubmitStudentExamEntity submission,
  }) {
    ExamSubmissionValidator.validate(submission);

    final SubmitStudentExamModel submissionModel =
        SubmitStudentExamModel.fromEntity(submission);

    return FirebaseErrorHandler.execute(() async {
      final HttpsCallable callable = _functions.httpsCallable(
        ExamCloudFunctions.submitExamAttempt,
        options: HttpsCallableOptions(timeout: _functionsTimeout),
      );

      final HttpsCallableResult<dynamic> response = await callable.call(
        submissionModel.toMap(),
      );

      final Map<String, dynamic> responseData =
          ExamRemoteResponseValidator.readMap(response.data);

      final Map<String, dynamic> resultData = _readSubmissionResult(
        responseData,
      );

      return StudentExamResultModel.fromMap(resultData).toEntity();
    }, timeout: _functionsTimeout);
  }

  Map<String, dynamic> _readSubmissionResult(
    Map<String, dynamic> responseData,
  ) {
    final dynamic rawResult = responseData[ExamCloudFunctionFields.result];

    if (rawResult is! Map) {
      return responseData;
    }

    final Map<String, dynamic> nestedResult =
        ExamRemoteResponseValidator.readMap(rawResult);

    return <String, dynamic>{...responseData, ...nestedResult};
  }
}
