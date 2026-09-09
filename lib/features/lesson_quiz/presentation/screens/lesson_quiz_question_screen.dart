import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_answer_option.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_auto_save_notice.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_header.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonQuizQuestionScreen extends StatelessWidget {
  const LessonQuizQuestionScreen({super.key});

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
          title: 'اختبار الكيمياء العضوية',
          trailingBadge: QuizProgressBadge(text: '${toArabicNumbers(4)} درجات'),
        ),
        body: SafeArea(
          top: false,
          child: Padding(
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
                        const QuizProgress(current: 1, total: 2),
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
                                'أي العناصر التالية يُعد من العناصر الانتقالية؟',
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style:
                                    AppTextStyle.font18TextPrimarySemiBoldKufam()
                                        .copyWith(
                                          color: ColorPalette.textPrimary,
                                        ),
                              ),
                              verticalSpace(16),
                              ..._answers.map(
                                (answer) => Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: QuizAnswerOption(
                                    title: answer,
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(14),
                        const QuizAutoSaveNotice(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 15.h),
                  child: CustomButton(text: 'التالي', onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
