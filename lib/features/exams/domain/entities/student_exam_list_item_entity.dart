import 'package:al_waleed/features/exams/domain/entities/student_exam_attempt_entity.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';

class StudentExamListItemEntity {
  const StudentExamListItemEntity({required this.exam, this.attempt});

  final StudentExamEntity exam;
  final StudentExamAttemptEntity? attempt;

  bool get hasAttempt => attempt != null;

  bool get shouldBeHidden => attempt?.isSubmitted == true;

  bool get canStart {
    return attempt == null && exam.isPublished;
  }

  bool canContinueAt(DateTime currentDate) {
    return attempt?.canContinueAt(currentDate) == true;
  }

  bool shouldAutoSubmitAt(DateTime currentDate) {
    return attempt?.shouldAutoSubmitAt(currentDate) == true;
  }
}
