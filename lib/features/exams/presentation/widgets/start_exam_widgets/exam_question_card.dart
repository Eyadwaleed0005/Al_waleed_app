import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/image_question.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/exam_answer_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamQuestionCard extends StatelessWidget {
  const ExamQuestionCard({
    super.key,
    this.questionText = 'أي المركبات التالية يُظهر ظاهرة التشاكل الهندسي؟',
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
    this.imageQuestion =
        'https://plus.unsplash.com/premium_photo-1681426678542-613c306013e1?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  });

  final String questionText;
  final String? imageQuestion;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            questionText,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font15TextPrimarySemiBoldKufam(),
          ),
          verticalSpace(14),
          if (imageQuestion != null) ...[
            ImageQuestion(image: imageQuestion),
            verticalSpace(16),
          ],
          ...List.generate(
            options.length,
            (index) => ExamAnswerOptionTile(
              text: options[index],
              isSelected: selectedIndex == index,
              onTap: () => onOptionSelected(index),
            ),
          ),
        ],
      ),
    );
  }
}
