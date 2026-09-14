import 'dart:math';

import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/lesson_quiz/domain/entity/lesson_quiz_result_entity.dart';
import 'package:al_waleed/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizResultCard extends StatelessWidget {
  const QuizResultCard({
    super.key,
    required this.result,
  });

  final LessonQuizResultEntity result;

  @override
  Widget build(BuildContext context) {
    final resultColor = result.isPassing
        ? ColorPalette.primary
        : ColorPalette.error;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 28.h,
      ),
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
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: resultColor,
                width: 2.w,
              ),
            ),
            child: Icon(
              result.isPassing
                  ? Icons.check_rounded
                  : Icons.close_rounded,
              color: resultColor,
              size: 32.sp,
            ),
          ),
          verticalSpace(16),
          _StudentResultTitle(
            isPassing: result.isPassing,
          ),
          verticalSpace(24),
          SizedBox(
            width: 140.w,
            height: 140.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _RingGaugePainter(
                    percentage: result.percentage,
                    trackColor: ColorPalette.paleSage,
                    progressColor: resultColor,
                    strokeWidth: 10.w,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${toArabicNumbers(result.earnedScore)} / '
                        '${toArabicNumbers(result.totalScore)}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: ColorPalette.textPrimary,
                          fontFamily: 'Tajawal',
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      verticalSpace(2),
                      Text(
                        '${toArabicNumbers(
                          (result.percentage * 100).round(),
                        )}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: resultColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(20),
          Text(
            _getSummaryText(
              correctAnswers: result.correctAnswersCount,
              totalQuestions: result.totalQuestions,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle
                .font14TextPrimaryMediumTajawal()
                .copyWith(
                  color: resultColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  String _getSummaryText({
    required int correctAnswers,
    required int totalQuestions,
  }) {
    final totalText = _getQuestionsCountText(totalQuestions);

    if (correctAnswers == 1) {
      return 'إجابة صحيحة واحدة من أصل $totalText';
    }

    if (correctAnswers == 2) {
      return 'إجابتان صحيحتان من أصل $totalText';
    }

    return '${toArabicNumbers(correctAnswers)} إجابات صحيحة '
        'من أصل $totalText';
  }

  String _getQuestionsCountText(int totalQuestions) {
    if (totalQuestions == 1) {
      return 'سؤال واحد';
    }

    if (totalQuestions == 2) {
      return 'سؤالين';
    }

    return '${toArabicNumbers(totalQuestions)} أسئلة';
  }
}

class _StudentResultTitle extends StatelessWidget {
  const _StudentResultTitle({
    required this.isPassing,
  });

  final bool isPassing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..initialize(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          var studentName = 'صديقي';

          if (state is ProfileSuccess) {
            studentName = state.profile.studentProfile.name;
          }

          return Text(
            isPassing
                ? 'أحسنت يا $studentName!'
                : 'حاول مرة أخرى يا $studentName!',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle
                .font20TextPrimarySemiBoldKufam()
                .copyWith(
                  color: isPassing
                      ? ColorPalette.primary
                      : ColorPalette.error,
                  fontWeight: FontWeight.w700,
                ),
          );
        },
      ),
    );
  }
}

class _RingGaugePainter extends CustomPainter {
  const _RingGaugePainter({
    required this.percentage,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double percentage;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final safePercentage = percentage.clamp(0.0, 1.0).toDouble();

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final diameter = min(
      size.width,
      size.height,
    );

    final radius = max(
      0.0,
      (diameter - strokeWidth) / 2,
    );

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    final sweepAngle = 2 * pi * safePercentage;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}