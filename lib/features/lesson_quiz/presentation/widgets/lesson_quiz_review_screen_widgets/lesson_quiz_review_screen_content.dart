import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_question_content_card.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_review_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizReviewScreenContent extends StatelessWidget {
  const LessonQuizReviewScreenContent({super.key});

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
          title: 'مراجعة الإجابات',
          trailingBadge: QuizProgressBadge(
            text: '${toArabicNumbers(4)} درجات',
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    12.h,
                    20.w,
                    16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const QuizProgress(
                        current: 1,
                        total: 2,
                        statusText: 'إجابة صحيحة',
                        statusColor: ColorPalette.success,
                      ),
                      verticalSpace(16),
                      const QuizQuestionContentCard(
                        questionText:
                            'أي العناصر التالية يُعد من العناصر الانتقالية؟',
                        answers: _answers,
                        selectedAnswer: 'الحديد',
                      ),
                      verticalSpace(16),
                      Text(
                        'الإجابة الصحيحة هي الحديد.',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style:
                            AppTextStyle.font12TextSecondaryRegularTajawal()
                                .copyWith(
                                  color: ColorPalette.textSecondary,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                child: QuizReviewNavigation(
                  isFirstQuestion: true,
                  isLastQuestion: false,
                  onPrevious: () {
                    Navigator.pop(context);
                  },
                  onNext: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
