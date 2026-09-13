import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';

abstract interface class StudentExamsRemoteDataSource {
  Stream<List<StudentExamEntity>> streamGradeExams({required String gradeId});

  Stream<List<StudentExamAttemptEntity>> streamStudentAttempts();

  Future<StudentExamSessionEntity> startExam({required String examId});

  Future<StudentExamSessionEntity> resumeExam({
    required String examId,
    required String resultId,
  });

  Future<StudentExamResultEntity> submitExam({
    required SubmitStudentExamEntity submission,
  });
}
