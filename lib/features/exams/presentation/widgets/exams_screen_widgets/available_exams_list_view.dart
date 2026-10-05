import 'dart:async';

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

class AvailableExamsListView extends StatefulWidget {
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
  State<AvailableExamsListView> createState() => _AvailableExamsListViewState();
}

class _AvailableExamsListViewState extends State<AvailableExamsListView> {
  Timer? _expiryTimer;

  @override
  void initState() {
    super.initState();
    _scheduleExpiryUpdate();
  }

  @override
  void didUpdateWidget(covariant AvailableExamsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleExpiryUpdate();
  }

  void _scheduleExpiryUpdate() {
    _expiryTimer?.cancel();
    _expiryTimer = null;

    final DateTime now = DateTime.now().toUtc();
    DateTime? nextExpiry;

    for (final StudentExamListItemEntity examItem in widget.exams) {
      final attempt = examItem.attempt;

      if (attempt == null || !attempt.canContinueAt(now)) {
        continue;
      }

      final DateTime expiresAt = attempt.expiresAt.toUtc();

      if (nextExpiry == null || expiresAt.isBefore(nextExpiry)) {
        nextExpiry = expiresAt;
      }
    }

    if (nextExpiry == null) {
      return;
    }

    _expiryTimer = Timer(nextExpiry.difference(now), () {
      if (!mounted) {
        return;
      }

      setState(() {});
      _scheduleExpiryUpdate();
    });
  }

  void _handleExamPressed(StudentExamListItemEntity examItem) {
    if (widget.openingExamId != null) {
      return;
    }

    final DateTime now = DateTime.now().toUtc();

    if (!examItem.canStart && !examItem.canContinueAt(now)) {
      setState(() {});
      _scheduleExpiryUpdate();
      return;
    }

    widget.onExamPressed(examItem);
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now().toUtc();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.exams.length,
      separatorBuilder: (BuildContext context, int index) {
        return verticalSpace(28);
      },
      itemBuilder: (BuildContext context, int index) {
        final StudentExamListItemEntity examItem = widget.exams[index];

        final bool isOpening =
            widget.openingExamId?.trim() == examItem.exam.examId.trim();

        final bool anotherExamIsOpening =
            widget.openingExamId != null && !isOpening;

        final bool shouldAutoSubmit = examItem.shouldAutoSubmitAt(currentDate);

        final bool canOpen =
            examItem.canStart || examItem.canContinueAt(currentDate);

        final bool canPress = !isOpening && !anotherExamIsOpening && canOpen;

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
              ExamAutoSaveNotice(
                title: 'تُحفظ إجاباتك تلقائيًا أثناء الحل',
                subtitle: examItem.hasAttempt
                    ? 'وقت المحاولة يستمر حتى أثناء خروجك من الاختبار.'
                    : 'تأكد من اتصال الإنترنت قبل بدء المحاولة.',
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
                          _handleExamPressed(examItem);
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

    return examItem.canStart ? 'ابدأ الامتحان' : 'الاختبار غير متاح';
  }
}
