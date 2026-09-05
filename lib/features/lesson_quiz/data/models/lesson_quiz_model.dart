import 'package:al_waleed/features/lesson_quiz/data/models/quiz_question_model.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entities/lesson_quiz_entity.dart';

class LessonQuizModel extends LessonQuizEntity {
  const LessonQuizModel({
    required super.id,
    required super.title,
    required super.questions,
  });

  factory LessonQuizModel.fromJson(Map<String, dynamic> json) {
    return LessonQuizModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => QuizQuestionModel.fromJson(q as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions
          .map((q) => (q as QuizQuestionModel).toJson())
          .toList(),
    };
  }
}
