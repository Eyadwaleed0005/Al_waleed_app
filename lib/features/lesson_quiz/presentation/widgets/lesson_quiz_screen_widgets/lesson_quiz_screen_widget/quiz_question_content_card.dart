import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_answer_option.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizQuestionContentCard extends StatelessWidget {
  const QuizQuestionContentCard({
    super.key,
    required this.questionText,
    required this.answers,
    this.questionImageUrl,
    this.selectedAnswer,
    this.onAnswerTap,
    this.isReviewMode = false,
    this.isCorrect = false,
  });

  final String questionText;
  final List<String> answers;
  final String? questionImageUrl;
  final String? selectedAnswer;
  final ValueChanged<String>? onAnswerTap;
  final bool isReviewMode;
  final bool isCorrect;

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
          if (questionImageUrl != null && questionImageUrl!.isNotEmpty) ...[
            verticalSpace(14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: questionImageUrl!,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    color: ColorPalette.divider,
                    child: const Center(
                      child: SizedBox(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: ColorPalette.divider,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: ColorPalette.textMuted,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
          verticalSpace(16),
          ...answers.map((answer) {
            bool? isAnswerCorrect;
            bool isAnswerSelected = answer == selectedAnswer;

            if (isReviewMode && isAnswerSelected) {
              isAnswerCorrect = isCorrect;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: QuizAnswerOption(
                title: answer,
                isSelected: isAnswerSelected,
                isCorrect: isAnswerCorrect,
                onTap: onAnswerTap != null ? () => onAnswerTap!(answer) : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}
