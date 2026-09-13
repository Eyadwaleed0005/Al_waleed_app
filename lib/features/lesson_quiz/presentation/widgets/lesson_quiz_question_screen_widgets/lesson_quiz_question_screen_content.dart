import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_result_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_auto_save_notice.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_question_content_card.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_question_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizQuestionScreenContent extends StatelessWidget {
  const LessonQuizQuestionScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: BlocBuilder<LessonQuizCubit, LessonQuizState>(
        builder: (context, state) {
          final cubit = context.read<LessonQuizCubit>();

          if (state is LessonQuizFailure) {
            return AppErrorState(
              message: state.errorMessage,
              onRetry: cubit.lessonId == null
                  ? null
                  : () => cubit.getQuizQuestions(lessonId: cubit.lessonId!),
            );
          }

          if (state is LessonQuizEmpty) {
            return AppEmptyState(
              title: 'عذراً، لا يوجد اختبار حالياً',
              icon: Icons.quiz_outlined,
              actionText: 'إعادة المحاولة',
              onAction: cubit.lessonId == null
                  ? null
                  : () => cubit.getQuizQuestions(lessonId: cubit.lessonId!),
            );
          }

          if (state is! LessonQuizSuccess) {
            return const QuizQuestionShimmer();
          }

          final question = state.questions[state.currentIndex];
          final isLastQuestion =
              state.currentIndex == state.questions.length - 1;

          return Padding(
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
                        QuizProgress(
                          current: state.currentIndex + 1,
                          total: state.questions.length,
                        ),
                        verticalSpace(16),
                        QuizQuestionContentCard(
                          questionText: question.questionText,
                          answers: question.options,
                         questionImageUrl: question.questionImageUrl,

                          selectedAnswer: question.selectedOption != null
                              ? question.options[question.selectedOption!]
                              : null,
                          onAnswerTap: (answer) {
                            cubit.selectAnswer(
                              questionIndex: state.currentIndex,
                              optionIndex: question.options.indexOf(answer),
                            );
                          },
                        ),
                        verticalSpace(14),
                        const QuizAutoSaveNotice(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 15.h),
                  child: CustomButton(
                    text: isLastQuestion ? 'إنهاء الاختبار' : 'التالي',
                    onPressed: question.selectedOption == null
                        ? null
                        : () {
                            if (isLastQuestion) {
                              cubit.submitQuiz();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: const LessonQuizResultScreen(),
                                  ),
                                ),
                              );
                            } else {
                              cubit.nextQuestion();
                            }
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
