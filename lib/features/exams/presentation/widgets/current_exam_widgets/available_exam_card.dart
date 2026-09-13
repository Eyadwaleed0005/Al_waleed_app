import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/exams/presentation/widgets/current_exam_widgets/exam_stat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableExamCard extends StatelessWidget {
  const AvailableExamCard({
    super.key,
    this.badgeText = 'متاح لصفك',
    this.title = 'اختبار الكيمياء العضوية',
    this.subtitle = 'الصف الثالث الثانوي',
    this.score = '40',
    this.scoreLabel = 'درجة',
    this.duration = '30',
    this.durationLabel = 'دقيقة',
    this.questionsCount = '20',
    this.questionsLabel = 'سؤالاً',
    this.remainingTime = '02:15:30',
  });

  final String badgeText;
  final String title;
  final String subtitle;
  final String score;
  final String scoreLabel;
  final String duration;
  final String durationLabel;
  final String questionsCount;
  final String questionsLabel;
  final String remainingTime;

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
                badgeText,
                style: AppTextStyle.font11TextHighlightBoldTajawal(),
              ),
            ),
          ),
          verticalSpace(12),
          Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font19TextLightSemiBoldKufam(),
          ),
          verticalSpace(4),
          Text(
            subtitle,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font12TextSoftSagaMediumTajawal(),
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: ExamStatItem(
                  value: questionsCount,
                  label: questionsLabel,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: ExamStatItem(value: duration, label: durationLabel),
              ),
              horizontalSpace(10),
              Expanded(
                child: ExamStatItem(value: score, label: scoreLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
