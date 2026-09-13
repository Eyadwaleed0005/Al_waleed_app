import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_result_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamSubmittedDetailsCard extends StatelessWidget {
  const ExamSubmittedDetailsCard({super.key, required this.result});

  final StudentExamResultEntity result;

  @override
  Widget build(BuildContext context) {
    final int percentage = result.percentage.round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _buildRow(label: 'حالة المحاولة', value: 'تم التسليم'),
            _buildDivider(),
            _buildRow(
              label: 'النتيجة',
              value:
                  '${toArabicNumbers(result.score)} / '
                  '${toArabicNumbers(result.totalScore)}',
            ),
            _buildDivider(),
            _buildRow(
              label: 'النسبة',
              value: '${toArabicNumbers(percentage)}٪',
            ),
            _buildDivider(),
            _buildRow(
              label: 'الإجابات الصحيحة',
              value: toArabicNumbers(result.correctAnswers),
            ),
            _buildDivider(),
            _buildRow(
              label: 'الإجابات الخاطئة',
              value: toArabicNumbers(result.wrongAnswers),
            ),
            _buildDivider(),
            _buildRow(
              label: 'الأسئلة غير المجابة',
              value: toArabicNumbers(result.unansweredQuestions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: const Divider(
        height: 1,
        thickness: 1,
        color: ColorPalette.divider,
      ),
    );
  }

  Widget _buildRow({required String label, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.font12TextSecondaryMediumTajawal(),
          ),
        ),
        horizontalSpace(12),
        Text(
          value,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font12TextPrimaryBoldTajawal(),
        ),
      ],
    );
  }
}
