import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherBanner extends StatelessWidget {
  const TeacherBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Material(
        color: ColorPalette.paleSage,
        child: SizedBox(
          width: double.infinity,
          height: 160.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      ColorPalette.primary,
                      ColorPalette.paleSage,
                      ColorPalette.paleMint,
                    ],
                    stops: [0, 0.5, 1],
                  ),
                ),
              ),
              const CustomPaint(painter: _TeacherBannerWavesPainter()),
              Positioned(
                left: 2.w,
                top: 0,
                bottom: 0,
                width: 140.w,
                child: Transform.scale(
                  scale: 1.07,
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    AppImage().teacherBanner,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              Positioned(
                right: 18.w,
                left: 145.w,
                top: 17.h,
                bottom: 16.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'مع الأستاذ وليد',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.font14TextPrimarySemiBoldKufam()
                          .copyWith(
                            fontSize: 13.sp,
                            color: ColorPalette.primary,
                          ),
                    ),
                    verticalSpace(12),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'افهم الكيمياء\nخطوة بخطوة',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: AppTextStyle.font20TextPrimarySemiBoldKufam()
                                .copyWith(
                                  fontSize: 21.sp,
                                  height: 1.55,
                                  color: ColorPalette.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(8),
                    Text(
                      'عن المدرّس',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.font12TextSecondaryRegularTajawal()
                          .copyWith(color: ColorPalette.primaryHover),
                    ),
                  ],
                ),
              ),
              Positioned.fill(child: InkWell(onTap: onTap)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherBannerWavesPainter extends CustomPainter {
  const _TeacherBannerWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final upperWave = Path()
      ..moveTo(0, size.height * 0.56)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.04,
        size.width * 0.35,
        size.height * 1.08,
        size.width * 0.77,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.67,
        size.width,
        size.height * 0.80,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      upperWave,
      Paint()..color = ColorPalette.softSage.withValues(alpha: 0.65),
    );

    final lowerWave = Path()
      ..moveTo(0, size.height * 0.94)
      ..cubicTo(
        size.width * 0.27,
        size.height * 0.48,
        size.width * 0.38,
        size.height * 1.19,
        size.width * 0.75,
        size.height * 0.91,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.80,
        size.width,
        size.height * 0.96,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(lowerWave, Paint()..color = ColorPalette.paleSage);
  }

  @override
  bool shouldRepaint(covariant _TeacherBannerWavesPainter oldDelegate) {
    return false;
  }
}
