import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/available_exams_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsScreenSuccessView extends StatelessWidget {
  const ExamsScreenSuccessView({
    super.key,
    required this.exams,
    required this.onExamPressed,
    this.openingExamId,
  });

  final List<StudentExamListItemEntity> exams;
  final ValueChanged<StudentExamListItemEntity> onExamPressed;
  final String? openingExamId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppAnimations.screenSection(
            delay: 100,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                exams.length == 1
                    ? 'اختبار متاح الآن'
                    : '${exams.length} اختبارات متاحة الآن',
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font13TextOceanBlueBoldTajawal(),
              ),
            ),
          ),
        ),
        verticalSpace(12),
        Expanded(
          child: AvailableExamsListView(
            exams: exams,
            openingExamId: openingExamId,
            onExamPressed: onExamPressed,
          ),
        ),
      ],
    );
  }
}
