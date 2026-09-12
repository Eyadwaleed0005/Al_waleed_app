import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';

class LessonQuizModel extends LessonQuizEntity {
  const LessonQuizModel({
    required super.lessonId,
    required super.questionText,
    super.questionImageUrl,
    required super.options,
    required super.correctOption,
    required super.questionScore,
  });

  factory LessonQuizModel.fromMap(Map<String, dynamic> map) {
    return LessonQuizModel(
      lessonId: map['lessonId'] ?? '',
      questionText: map['questionText'] ?? '',
      questionImageUrl: map['questionImageUrl'],
      options: [
        map['option1'] ?? '',
        map['option2'] ?? '',
        map['option3'] ?? '',
        map['option4'] ?? '',
      ],
      correctOption: map['correctOption'] ?? 1,
      questionScore: map['questionScore'] ?? 1,
    );
  }
}