import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_entity.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/current_exam_widgets/exam_stat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableExamCard extends StatelessWidget {
  const AvailableExamCard({super.key, required this.exam});

  final StudentExamEntity exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ColorPalette.deepOlive,
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
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: ColorPalette.goldHighlight.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'متاح لصفك',
                style: AppTextStyle.font11TextHighlightBoldTajawal(),
              ),
            ),
          ),
          verticalSpace(12),
          Text(
            exam.examName,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font19TextLightSemiBoldKufam(),
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: ExamStatItem(
                  value: exam.questionCount.toString(),
                  label: 'سؤال',
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: ExamStatItem(
                  value: exam.durationMinutes.toString(),
                  label: 'دقيقة',
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: ExamStatItem(
                  value: exam.totalScore.toString(),
                  label: 'درجة',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
