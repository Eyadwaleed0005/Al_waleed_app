import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/exam_answer_option_tile.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/image_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamQuestionCard extends StatelessWidget {
  const ExamQuestionCard({
    super.key,
    required this.questionText,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
    this.imageQuestion,
    this.isEnabled = true,
  });

  final String questionText;
  final String? imageQuestion;
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onOptionSelected;
  final bool isEnabled;

  bool get _hasImage {
    return imageQuestion?.trim().isNotEmpty == true;
  }

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
          if (_hasImage) ...[
            ImageQuestion(image: imageQuestion!),
            verticalSpace(16),
          ],
          IgnorePointer(
            ignoring: !isEnabled,
            child: Opacity(
              opacity: isEnabled ? 1 : 0.65,
              child: Column(
                children: List<Widget>.generate(options.length, (int index) {
                  return ExamAnswerOptionTile(
                    text: options[index],
                    isSelected: selectedIndex == index,
                    onTap: () {
                      onOptionSelected(index);
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
