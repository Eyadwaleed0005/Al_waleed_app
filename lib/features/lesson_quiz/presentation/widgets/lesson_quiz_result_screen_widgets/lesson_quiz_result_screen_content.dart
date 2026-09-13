import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_review_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_info_card.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizResultScreenContent extends StatelessWidget {
  const LessonQuizResultScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const QuizHeader(
          title: 'نتيجة اختبار الدرس',
          showBackButton: true,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QuizResultCard(score: score, total: totalQuestions),
                      verticalSpace(16),
                      QuizInfoCard(
                        scoreText:
                            '${toArabicNumbers(score * 2)} من '
                            '${toArabicNumbers(totalQuestions * 2)}',
                        retryText: 'متاحة',
                      ),
                      verticalSpace(16),
                      Text(
                        'يمكنك إعادة الاختبار لتحسين درجتك.',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyle.font12TextSecondaryRegularTajawal()
                            .copyWith(color: ColorPalette.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSecondaryButton(
                      text: 'مراجعة الإجابات',
                      onPressed: onReviewAnswers ?? () {},
                    ),
                    verticalSpace(10),
                    CustomButton(
                      text: 'إعادة الاختبار',
                      onPressed: onRetryQuiz ?? () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
