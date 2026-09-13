import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/features/app_startup/domain/entities/student_access_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/submit_student_exam_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class StudentExamsRepository {
  Stream<Either<AppErrorModel, List<StudentExamListItemEntity>>>
  streamAvailableExams({required StudentAccessEntity studentAccess});

  Future<Either<AppErrorModel, StudentExamSessionEntity>> startExam({
    required String examId,
  });

  Future<Either<AppErrorModel, StudentExamSessionEntity>> resumeExam({
    required String examId,
    required String resultId,
  });

  Future<Either<AppErrorModel, StudentExamResultEntity>> submitExam({
    required SubmitStudentExamEntity submission,
  });
}
