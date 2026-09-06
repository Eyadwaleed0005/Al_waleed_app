import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_state.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_answer_option.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_review_navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizReviewScreen extends StatelessWidget {
  const LessonQuizReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: BlocBuilder<LessonQuizCubit, LessonQuizState>(
        builder: (context, state) {
          if (state is! LessonQuizActive) return const SizedBox.shrink();

          final cubit = context.read<LessonQuizCubit>();
          final question = state.quiz.questions[state.reviewQuestionIndex];
          final userSelected = state.selectedAnswers[question.id];
          final isUserCorrect = userSelected == question.correctAnswer;
          final isFirst = state.isFirstReviewQuestion;
          final isLast = state.isLastReviewQuestion;

          return BackgroundStudentLayout(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: QuizHeader(
                title: 'مراجعة الإجابات',
                trailingBadge: QuizProgressBadge(
                  text: '${toArabicNumbers(state.score * 2)} درجة',
                ),
                onBack: () {
                  if (isFirst) {
                    cubit.endReview();
                  } else {
                    cubit.previousReviewQuestion();
                  }
                },
              ),
              body: SafeArea(
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
                              current: state.reviewQuestionIndex + 1,
                              total: state.totalQuestions,
                              statusText: isUserCorrect ? 'إجابة صحيحة' : 'إجابة خاطئة',
                              statusColor: isUserCorrect
                                  ? ColorPalette.success
                                  : ColorPalette.error,
                            ),
                            verticalSpace(16),
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: ColorPalette.surface,
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: ColorPalette.ligthBlackShadow,
                                    blurRadius: 16,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    question.text,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: AppTextStyle.font18TextPrimarySemiBoldKufam().copyWith(
                                      color: ColorPalette.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  verticalSpace(16),
                                  if (question.imageUrl != null) ...[
                                    Container(
                                      width: double.infinity,
                                      constraints: BoxConstraints(maxHeight: 120.h),
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primarySoftBackground,
                                        borderRadius: BorderRadius.circular(14.r),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: question.imageUrl!,
                                        fit: BoxFit.contain,
                                        errorWidget: (context, url, error) => Center(
                                          child: Text(
                                            'تعذّر تحميل الصورة',
                                            style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    verticalSpace(16),
                                  ],
                                  ...List.generate(question.options.length, (i) {
                                    final option = question.options[i];
                                    final answerState = _resolveReviewState(
                                      option: option,
                                      userSelected: userSelected,
                                      correctAnswer: question.correctAnswer,
                                    );

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: QuizAnswerOption(
                                        title: option,
                                        answerState: answerState,
                                        index: i,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            verticalSpace(16),
                            Center(
                              child: Text(
                                'الإجابة الصحيحة موضحة باللون الأخضر.',
                                style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                                  color: ColorPalette.textSecondary,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            verticalSpace(16),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                      child: QuizReviewNavigation(
                        isFirstQuestion: isFirst,
                        isLastQuestion: isLast,
                        onPrevious: cubit.previousReviewQuestion,
                        onNext: isLast ? cubit.endReview : cubit.nextReviewQuestion,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AnswerState _resolveReviewState({
    required String option,
    required String? userSelected,
    required String correctAnswer,
  }) {
    final isCorrect = option == correctAnswer;
    final isSelected = option == userSelected;

    if (isCorrect && isSelected) return AnswerState.correctSelected;
    if (isCorrect && !isSelected) return AnswerState.correctUnselected;
    if (!isCorrect && isSelected) return AnswerState.incorrectSelected;
    return AnswerState.neutral;
  }
}
