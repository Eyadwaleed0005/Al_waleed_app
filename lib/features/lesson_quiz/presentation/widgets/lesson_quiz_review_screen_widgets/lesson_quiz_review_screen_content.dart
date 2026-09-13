import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_question_content_card.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_review_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizReviewScreenContent extends StatefulWidget {
  const LessonQuizReviewScreenContent({super.key});

  @override
  State<LessonQuizReviewScreenContent> createState() =>
      _LessonQuizReviewScreenContentState();
}

class _LessonQuizReviewScreenContentState
    extends State<LessonQuizReviewScreenContent> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: QuizHeader(
          title: 'مراجعة الإجابات',
          trailingBadge: QuizProgressBadge(text: '${toArabicNumbers(4)} درجات'),
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
                      QuizProgress(
                        current: _index + 1,
                        total: state.questions.length,
                        statusText: isCorrect ? 'إجابة صحيحة' : 'إجابة خاطئة',
                        statusColor: isCorrect
                            ? ColorPalette.success
                            : ColorPalette.error,
                      ),
                      verticalSpace(16),
                      Text(
                        'الإجابة الصحيحة هي الحديد.',
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
                child: QuizReviewNavigation(
                  isFirstQuestion: _index == 0,
                  isLastQuestion: isLastQuestion,
                  onPrevious: _index == 0
                      ? () => Navigator.pop(context)
                      : () => setState(() => _index--),
                  onNext: isLastQuestion
                      ? () => Navigator.pop(context)
                      : () => setState(() => _index++),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
