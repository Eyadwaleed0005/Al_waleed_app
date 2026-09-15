import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_entity.dart';
import 'package:al_waleed/features/lesson_quiz/domain/usecase/calculate_lesson_quiz_result_use_case.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_session_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_result_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_auto_save_notice.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_question_content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizSuccessView extends StatelessWidget {
  const LessonQuizSuccessView({super.key, required this.quiz});

  final LessonQuizEntity quiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return LessonQuizSessionCubit(
          quiz: quiz,
          calculateResultUseCase: getIt<CalculateLessonQuizResultUseCase>(),
        );
      },
      child: const _LessonQuizSessionContent(),
    );
  }
}

class _LessonQuizSessionContent extends StatelessWidget {
  const _LessonQuizSessionContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonQuizSessionCubit, LessonQuizSessionState>(
      builder: (context, state) {
        final sessionCubit = context.read<LessonQuizSessionCubit>();

        final question = state.currentQuestion;

        if (question == null) {
          return const SizedBox.shrink();
        }

        _getSelectedAnswer(
          options: question.options,
          selectedOptionIndex: state.currentSelectedOption,
        );

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: QuizHeader(
            title: 'اختبار الدرس',
            showBackButton: true,
            trailingBadge: QuizProgressBadge(
              text: '${toArabicNumbers(question.score)} درجات',
            ),
          ),
          body: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 18.h, bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuizProgress(
                            current: state.currentIndex + 1,
                            total: state.quiz.questions.length,
                          ),
                          verticalSpace(18),
                          QuizQuestionContentCard(
                            questionText: question.questionText,
                            questionImageUrl: question.questionImageUrl,
                            answers: question.options,
                            selectedAnswerIndex: state.currentSelectedOption,
                            onAnswerTap: (optionIndex) {
                              sessionCubit.selectAnswer(
                                questionId: question.questionId,
                                optionIndex: optionIndex,
                              );
                            },
                          ),
                          verticalSpace(16),
                          const QuizAutoSaveNotice(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: state.isLastQuestion
                            ? 'إنهاء الاختبار'
                            : 'التالي',
                        onPressed: !state.isCurrentQuestionAnswered
                            ? null
                            : () {
                                _handleNextAction(
                                  context: context,
                                  sessionCubit: sessionCubit,
                                  isLastQuestion: state.isLastQuestion,
                                );
                              },
                      ),
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

  String? _getSelectedAnswer({
    required List<String> options,
    required int? selectedOptionIndex,
  }) {
    if (selectedOptionIndex == null ||
        selectedOptionIndex < 0 ||
        selectedOptionIndex >= options.length) {
      return null;
    }

    return options[selectedOptionIndex];
  }

  void _handleNextAction({
    required BuildContext context,
    required LessonQuizSessionCubit sessionCubit,
    required bool isLastQuestion,
  }) {
    if (!isLastQuestion) {
      sessionCubit.nextQuestion();
      return;
    }

    sessionCubit.submitQuiz();

    final sessionState = sessionCubit.state;

    if (!sessionState.isSubmitted || sessionState.result == null) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider.value(
            value: sessionCubit,
            child: const LessonQuizResultScreen(),
          );
        },
      ),
    );
  }
}
