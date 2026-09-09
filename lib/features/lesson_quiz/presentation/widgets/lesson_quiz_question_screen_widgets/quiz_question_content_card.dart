import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_answer_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizQuestionContentCard extends StatelessWidget {
  const QuizQuestionContentCard({
    super.key,
    required this.questionText,
    required this.answers,
    this.selectedAnswer,
    this.onAnswerTap,
  });

  final String questionText;
  final List<String> answers;
  final String? selectedAnswer;
  final ValueChanged<String>? onAnswerTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            questionText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font18TextPrimarySemiBoldKufam().copyWith(
              color: ColorPalette.textPrimary,
            ),
          ),
          verticalSpace(16),
          ...answers.map(
            (answer) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: QuizAnswerOption(
                title: answer,
                isSelected: answer == selectedAnswer,
                onTap: onAnswerTap != null ? () => onAnswerTap!(answer) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
