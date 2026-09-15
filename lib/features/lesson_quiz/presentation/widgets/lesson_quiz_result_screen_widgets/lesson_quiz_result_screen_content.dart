import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_session_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_review_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_result_screen_widgets/quiz_result_card.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizResultScreenContent extends StatelessWidget {
  const LessonQuizResultScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonQuizSessionCubit, LessonQuizSessionState>(
      builder: (context, state) {
        final result = state.result;

        return BackgroundStudentLayout(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: QuizHeader(
              title: 'نتيجة اختبار الدرس',
              showBackButton: true,
              onBack: () {
                _returnToLessonDetails(context);
              },
            ),
            body: result == null
                ? const Center(
                    child: Text(
                      'تعذر عرض نتيجة الاختبار.',
                      textDirection: TextDirection.rtl,
                    ),
                  )
                : SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                QuizResultCard(result: result),
                                verticalSpace(16),
                                QuizInfoCard(
                                  scoreText:
                                      '${toArabicNumbers(result.earnedScore)} من '
                                      '${toArabicNumbers(result.totalScore)}',
                                  retryText: 'متاحة',
                                ),
                                verticalSpace(16),
                                Text(
                                  'يمكنك إعادة الاختبار لتحسين درجتك.',
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomSecondaryButton(
                                text: 'مراجعة الإجابات',
                                onPressed: () {
                                  _openReviewScreen(context);
                                },
                              ),
                              verticalSpace(10),
                              CustomButton(
                                text: 'إعادة الاختبار',
                                onPressed: () {
                                  _restartQuiz(context);
                                },
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
    );
  }

  void _returnToLessonDetails(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == RouteNames.lessonDetails || route.isFirst;
    });
  }

  void _openReviewScreen(BuildContext context) {
    final sessionCubit = context.read<LessonQuizSessionCubit>();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return BlocProvider.value(
            value: sessionCubit,
            child: const LessonQuizReviewScreen(),
          );
        },
      ),
    );
  }

  void _restartQuiz(BuildContext context) {
    context.read<LessonQuizSessionCubit>().restartQuiz();
    Navigator.of(context).pop();
  }
}
