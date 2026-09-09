import 'package:al_waleed/features/lesson_quiz/data/data_sources/lesson_quiz_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/models/lesson_quiz_model.dart';
import 'package:al_waleed/features/lesson_quiz/data/models/quiz_question_model.dart';

/// Provides a static mock quiz for organic chemistry — two questions with
/// known correct/incorrect mock selections used in the full acceptance test.
class MockLessonQuizDataSource implements LessonQuizDataSource {
  static const LessonQuizModel _mockQuiz = LessonQuizModel(
    id: 'organic_chemistry_quiz_1',
    title: 'اختبار الكيمياء العضوية',
    questions: [
      QuizQuestionModel(
        id: 'q1',
        text: 'ما اسم المركب العضوي الموضح في الصورة؟',
        options: ['الإيثانول', 'الفينول', 'البنزين', 'حمض الإيثانويك'],
        correctAnswer: 'الإيثانول',
        imageUrl:
            'https://d10lpgp6xz60nq.cloudfront.net/physics_images/KSV_CHM_ORG_P2_C10_E01_164_O04.png',
      ),
      QuizQuestionModel(
        id: 'q2',
        text: 'أي العوامل التالية يؤثر قيمة ثابت الاتزان؟',
        options: ['التركيز', 'الضغط', 'العامل الحفاز', 'درجة الحرارة'],
        correctAnswer: 'درجة الحرارة',
      ),
    ],
  );

  @override
  Future<LessonQuizModel> getLessonQuiz() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _mockQuiz;
  }
}
