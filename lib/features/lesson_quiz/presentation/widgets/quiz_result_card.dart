import 'dart:math';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizResultCard extends StatelessWidget {
  const QuizResultCard({
    super.key,
    required this.score,
    required this.total,
  });

  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : score / total;
    final isPassing = percentage >= 0.5;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
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
                color: isPassing ? ColorPalette.primary : ColorPalette.error,
                width: 2.w,
              ),
            ),
            child: Icon(
              isPassing ? Icons.check_rounded : Icons.close_rounded,
              color: isPassing ? ColorPalette.primary : ColorPalette.error,
              size: 32.sp,
            ),
          ),
          verticalSpace(16),
          Text(
            isPassing ? 'أحسنت يا جلال!' : 'حاول مرة أخرى!',
            style: AppTextStyle.font20TextPrimarySemiBoldKufam().copyWith(
              color: ColorPalette.primary,
              fontWeight: FontWeight.w700,
            ),
            textDirection: TextDirection.rtl,
          ),
          verticalSpace(4),
          Text(
            'اختبار الكيمياء العضوية',
            style: AppTextStyle.font13TextSecondaryRegularTajawal().copyWith(
              color: ColorPalette.textSecondary,
            ),
            textDirection: TextDirection.rtl,
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
                    percentage: percentage,
                    trackColor: ColorPalette.paleSage,
                    progressColor: ColorPalette.primary,
                    strokeWidth: 10.w,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${score * 2} / ${total * 2}',
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
                        '${(percentage * 100).round()}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorPalette.secondary,
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
            _getSummaryText(score, total),
            style: AppTextStyle.font14TextPrimaryMediumTajawal().copyWith(
              color: ColorPalette.primary,
              fontWeight: FontWeight.w700,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  String _getSummaryText(int score, int total) {
    final totalText = total == 2 ? 'سؤالين' : '$total أسئلة';
    if (score == 1) {
      return 'إجابة صحيحة من أصل $totalText';
    } else if (score == 2) {
      return 'إجابتان صحيحتان من أصل $totalText';
    } else {
      return '$score إجابات صحيحة من أصل $totalText';
    }
  }
}

class _RingGaugePainter extends CustomPainter {
  _RingGaugePainter({
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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

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

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
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
        oldDelegate.progressColor != progressColor;
  }
}
