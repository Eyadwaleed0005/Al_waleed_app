import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_state.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_answer_option.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_progress.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_validation_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizQuestionScreen extends StatelessWidget {
  const LessonQuizQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: BlocBuilder<LessonQuizCubit, LessonQuizState>(
        builder: (context, state) {
          if (state is! LessonQuizActive) return const SizedBox.shrink();

          final cubit = context.read<LessonQuizCubit>();
          final question = state.quiz.questions[state.currentQuestionIndex];
          final selected = state.selectedAnswerForCurrentQuestion;
          final isFirst = state.currentQuestionIndex == 0;
          final isLast = state.isLastQuestion;

          return BackgroundStudentLayout(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: QuizHeader(
                title: state.quiz.title,
                trailingBadge: QuizProgressBadge(
                  text: '${toArabicNumbers(state.totalQuestions * 2)} درجات',
                ),
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
                              current: state.currentQuestionIndex + 1,
                              total: state.totalQuestions,
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
                                    final answerState = option == selected
                                        ? AnswerState.selected
                                        : AnswerState.neutral;

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: QuizAnswerOption(
                                        title: option,
                                        answerState: answerState,
                                        index: i,
                                        onTap: () => cubit.selectAnswer(option),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            verticalSpace(14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.rtl,
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 16.sp,
                                  color: ColorPalette.textSecondary,
                                ),
                                horizontalSpace(6),
                                Text(
                                  'يتم حفظ إجابتك تلقائياً أثناء الاختبار.',
                                  style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                                    color: ColorPalette.textSecondary,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            if (state.validationMessage != null) ...[
                              verticalSpace(8),
                              QuizValidationMessage(message: state.validationMessage!),
                            ],
                            verticalSpace(16),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 15.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isFirst) ...[
                            CustomSecondaryButton(
                              text: 'السابق',
                              onPressed: cubit.previousQuestion,
                            ),
                            verticalSpace(10),
                          ],
                          if (isLast)
                            CustomButton(
                              text: 'تسليم الاختبار',
                              onPressed: cubit.submitQuiz,
                              background: ColorPalette.surface,
                              borderColor: const Color(0xFFFECDD3),
                              foreground: ColorPalette.error,
                            )
                          else
                            CustomButton(
                              text: 'التالي',
                              onPressed: cubit.nextQuestion,
                            ),
                        ],
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
}
