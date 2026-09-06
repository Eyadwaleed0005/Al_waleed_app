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
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_info_card.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/quiz_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizResultScreen extends StatelessWidget {
  const LessonQuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: BlocBuilder<LessonQuizCubit, LessonQuizState>(
        builder: (context, state) {
          if (state is! LessonQuizActive) return const SizedBox.shrink();

          final cubit = context.read<LessonQuizCubit>();

          return BackgroundStudentLayout(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const QuizHeader(
                title: 'نتيجة اختبار الدرس',
                showBackButton: true,
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
                            QuizResultCard(
                              score: state.score,
                              total: state.totalQuestions,
                            ),
                            verticalSpace(16),
                            QuizInfoCard(
                              scoreText: '${toArabicNumbers(state.score * 2)} من ${toArabicNumbers(state.totalQuestions * 2)}',
                              retryText: 'متاحة',
                            ),
                            verticalSpace(16),
                            Center(
                              child: Text(
                                'يمكنك إعادة الاختبار لتحسين درجتك.',
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSecondaryButton(
                            text: 'مراجعة الإجابات',
                            onPressed: cubit.startReview,
                          ),
                          verticalSpace(10),
                          CustomButton(
                            text: 'إعادة الاختبار',
                            onPressed: cubit.retryQuiz,
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
