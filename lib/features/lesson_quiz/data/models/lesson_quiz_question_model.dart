import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_question_entity.dart';

class LessonQuizQuestionModel extends LessonQuizQuestionEntity {
  const LessonQuizQuestionModel({
    required super.questionId,
    required super.questionText,
    super.questionImageUrl,
    required super.options,
    required super.correctOptionIndex,
    required super.score,
  });

  factory LessonQuizQuestionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    final options = <String>[
      map[FirestoreFields.option1] as String? ?? '',
      map[FirestoreFields.option2] as String? ?? '',
      map[FirestoreFields.option3] as String? ?? '',
      map[FirestoreFields.option4] as String? ?? '',
    ];

    final storedCorrectOption =
        (map[FirestoreFields.correctOption] as num?)?.toInt() ?? 1;

    final correctOptionIndex = (storedCorrectOption - 1)
        .clamp(0, options.length - 1)
        .toInt();

    final imageUrl = map[FirestoreFields.questionImageUrl];

    return LessonQuizQuestionModel(
      questionId: map[FirestoreFields.questionId] as String? ?? '',
      questionText: map[FirestoreFields.questionText] as String? ?? '',
      questionImageUrl: imageUrl is String && imageUrl.trim().isNotEmpty
          ? imageUrl
          : null,
      options: options,
      correctOptionIndex: correctOptionIndex,
      score:
          (map[FirestoreFields.questionScore] as num?)?.toInt() ?? 1,
    );
  }
}