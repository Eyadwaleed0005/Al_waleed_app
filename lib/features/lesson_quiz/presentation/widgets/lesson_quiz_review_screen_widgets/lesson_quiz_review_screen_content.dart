import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_session_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_review_screen_widgets/quiz_review_navigation.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_question_content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizReviewScreenContent extends StatefulWidget {
  const LessonQuizReviewScreenContent({super.key});

  @override
  State<LessonQuizReviewScreenContent> createState() {
    return _LessonQuizReviewScreenContentState();
  }
}

class _LessonQuizReviewScreenContentState
    extends State<LessonQuizReviewScreenContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonQuizSessionCubit, LessonQuizSessionState>(
      builder: (context, state) {
        final questions = state.quiz.questions;

        if (questions.isEmpty) {
          return const BackgroundStudentLayout(
            child: Center(
              child: Text(
                'لا توجد أسئلة للمراجعة.',
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }

        final question = questions[_currentIndex];
        final selectedOptionIndex = state.selectedAnswers[question.questionId];

        _getAnswerByIndex(
          options: question.options,
          optionIndex: selectedOptionIndex,
        );

        final correctAnswer = _getAnswerByIndex(
          options: question.options,
          optionIndex: question.correctOptionIndex,
        );

        final isCorrect = selectedOptionIndex == question.correctOptionIndex;

        final isFirstQuestion = _currentIndex == 0;
        final isLastQuestion = _currentIndex == questions.length - 1;

        return BackgroundStudentLayout(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: QuizHeader(
              title: 'مراجعة الإجابات',
              trailingBadge: QuizProgressBadge(
                text: '${toArabicNumbers(question.score)} درجات',
              ),
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
                            current: _currentIndex + 1,
                            total: questions.length,
                            statusText: isCorrect
                                ? 'إجابة صحيحة'
                                : 'إجابة خاطئة',
                            statusColor: isCorrect
                                ? ColorPalette.success
                                : ColorPalette.error,
                          ),
                          verticalSpace(16),
                          QuizQuestionContentCard(
                            questionText: question.questionText,
                            questionImageUrl: question.questionImageUrl,
                            answers: question.options,
                            selectedAnswerIndex: selectedOptionIndex,
                            isReviewMode: true,
                            isCorrect: isCorrect,
                          ),
                          verticalSpace(12),
                          if (!isCorrect && correctAnswer != null)
                            Text(
                              'الإجابة الصحيحة هي: $correctAnswer',
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
                      isFirstQuestion: isFirstQuestion,
                      isLastQuestion: isLastQuestion,
                      onPrevious: () {
                        _handlePrevious(isFirstQuestion: isFirstQuestion);
                      },
                      onNext: () {
                        _handleNext(isLastQuestion: isLastQuestion);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _getAnswerByIndex({
    required List<String> options,
    required int? optionIndex,
  }) {
    if (optionIndex == null ||
        optionIndex < 0 ||
        optionIndex >= options.length) {
      return null;
    }

    return options[optionIndex];
  }

  void _handlePrevious({required bool isFirstQuestion}) {
    if (isFirstQuestion) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _currentIndex--;
    });
  }

  void _handleNext({required bool isLastQuestion}) {
    if (isLastQuestion) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _currentIndex++;
    });
  }
}
