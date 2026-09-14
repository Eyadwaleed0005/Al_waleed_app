import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_result_entity.dart';

class CalculateLessonQuizResultUseCase {
  const CalculateLessonQuizResultUseCase();

  LessonQuizResultEntity call({
    required LessonQuizEntity quiz,
    required Map<String, int> selectedAnswers,
  }) {
    var correctAnswersCount = 0;
    var earnedScore = 0;
    var totalScore = 0;

    for (final question in quiz.questions) {
      totalScore += question.score;

      final selectedOption = selectedAnswers[question.questionId];

      if (selectedOption == question.correctOptionIndex) {
        correctAnswersCount++;
        earnedScore += question.score;
      }
    }

    return LessonQuizResultEntity(
      correctAnswersCount: correctAnswersCount,
      totalQuestions: quiz.questions.length,
      earnedScore: earnedScore,
      totalScore: totalScore,
    );
  }
}