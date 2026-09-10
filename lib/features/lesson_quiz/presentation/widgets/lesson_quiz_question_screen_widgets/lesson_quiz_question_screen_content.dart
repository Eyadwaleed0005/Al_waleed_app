import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_auto_save_notice.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_question_content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizQuestionScreenContent extends StatelessWidget {
  const LessonQuizQuestionScreenContent({super.key});

  static const List<String> _answers = [
    'الصوديوم',
    'الحديد',
    'الكالسيوم',
    'المغنيسيوم',
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: QuizHeader(
          title: 'اختبار الكيمياء العضوية',
          trailingBadge: QuizProgressBadge(text: '${toArabicNumbers(4)} درجات'),
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const QuizProgress(current: 1, total: 2),
                        verticalSpace(16),
                        const QuizQuestionContentCard(
                          questionText: 'أي العناصر التالية يُعد من العناصر الانتقالية؟',
                          answers: _answers,
                        ),
                        verticalSpace(14),
                        const QuizAutoSaveNotice(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 15.h),
                  child: CustomButton(text: 'التالي', onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
