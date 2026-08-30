import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizAnswerOption extends StatelessWidget {
  const QuizAnswerOption({
    super.key,
    required this.title,
    required this.answerState,
    this.onTap,
    this.index,
  });

  final String title;
  final AnswerState answerState;
  final VoidCallback? onTap;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final style = _styleForState(answerState);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: style.border, width: style.borderWidth),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _RadioIndicator(answerState: answerState),
            horizontalSpace(12),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font15TextPrimaryMediumTajawal().copyWith(
                  color: style.textColor,
                  fontWeight: answerState != AnswerState.neutral ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _AnswerStyle _styleForState(AnswerState state) {
    switch (state) {
      case AnswerState.selected:
        return const _AnswerStyle(
          background: Color(0xFFEBF5FC),
          border: ColorPalette.secondary,
          textColor: ColorPalette.secondary,
          borderWidth: 1.5,
        );
      case AnswerState.correctSelected:
      case AnswerState.correctUnselected:
        return const _AnswerStyle(
          background: Color(0xFFEAF7EF),
          border: ColorPalette.softSage,
          textColor: ColorPalette.success,
          borderWidth: 1.5,
        );
      case AnswerState.incorrectSelected:
        return const _AnswerStyle(
          background: Color(0xFFFDE8E8),
          border: Color(0xFFF87171),
          textColor: ColorPalette.error,
          borderWidth: 1.5,
        );
      case AnswerState.neutral:
        return const _AnswerStyle(
          background: ColorPalette.surface,
          border: ColorPalette.divider,
          textColor: ColorPalette.textPrimary,
          borderWidth: 1.0,
        );
    }
  }
}

class _AnswerStyle {
  const _AnswerStyle({
    required this.background,
    required this.border,
    required this.textColor,
    required this.borderWidth,
  });

  final Color background;
  final Color border;
  final Color textColor;
  final double borderWidth;
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.answerState});

  final AnswerState answerState;

  @override
  Widget build(BuildContext context) {
    final (outerBorderColor, innerFillColor, isFilled) = _resolveRadioColors();

    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: outerBorderColor, width: 2.w),
      ),
      child: isFilled
          ? Center(
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: innerFillColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  (Color, Color, bool) _resolveRadioColors() {
    switch (answerState) {
      case AnswerState.selected:
        return (ColorPalette.secondary, ColorPalette.secondary, true);
      case AnswerState.correctSelected:
      case AnswerState.correctUnselected:
        return (ColorPalette.success, ColorPalette.success, true);
      case AnswerState.incorrectSelected:
        return (ColorPalette.error, ColorPalette.error, true);
      case AnswerState.neutral:
        return (ColorPalette.textMuted, Colors.transparent, false);
    }
  }
}
