import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_list_item_entity.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/current_exam_widgets/available_exam_card.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/current_exam_widgets/exam_auto_save_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableExamsListView extends StatelessWidget {
  const AvailableExamsListView({
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
    final DateTime currentDate = DateTime.now().toUtc();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: exams.length,
      separatorBuilder: (BuildContext context, int index) {
        return verticalSpace(28);
      },
      itemBuilder: (BuildContext context, int index) {
        final StudentExamListItemEntity examItem = exams[index];

        final bool isOpening =
            openingExamId?.trim() == examItem.exam.examId.trim();

        final bool anotherExamIsOpening = openingExamId != null && !isOpening;

        final bool shouldAutoSubmit = examItem.shouldAutoSubmitAt(currentDate);

        final bool canPress =
            !isOpening && !anotherExamIsOpening && !shouldAutoSubmit;

        final String buttonText = _buttonText(
          examItem: examItem,
          shouldAutoSubmit: shouldAutoSubmit,
        );

        final double buttonOpacity = isOpening || canPress ? 1 : 0.65;

        return AppAnimations.screenSection(
          delay: 150 + (index * 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AvailableExamCard(exam: examItem.exam),
              verticalSpace(18),
              const ExamAutoSaveNotice(
                title: 'تُحفظ إجاباتك تلقائيًا أثناء الحل',
                subtitle: 'تأكد من اتصال الإنترنت قبل بدء المحاولة.',
              ),
              verticalSpace(22),
              IgnorePointer(
                ignoring: !canPress,
                child: Opacity(
                  opacity: buttonOpacity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomButton(
                        text: isOpening ? '' : buttonText,
                        onPressed: () {
                          onExamPressed(examItem);
                        },
                        background: ColorPalette.primary,
                        foreground: ColorPalette.textLight,
                        height: 52.h,
                      ),
                      if (isOpening)
                        const Positioned.fill(
                          child: Center(
                            child: AppLoadingIndicator(
                              color: ColorPalette.surface,
                              size: 24,
                              strokeWidth: 3,
                              wavelength: 12,
                              waveSpeed: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (examItem.canStart) ...[
                verticalSpace(10),
                Text(
                  'بمجرد البدء سيعمل المؤقت ولا يمكن إيقافه.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font11TextSecondaryRegularTajawal(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _buttonText({
    required StudentExamListItemEntity examItem,
    required bool shouldAutoSubmit,
  }) {
    if (shouldAutoSubmit) {
      return 'بانتظار تسليم الاختبار';
    }

    if (examItem.hasAttempt) {
      return 'استمرار الاختبار';
    }

    return 'ابدأ الامتحان';
  }
}
