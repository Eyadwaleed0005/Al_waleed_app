import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m3e_progress_indicator/m3e_progress_indicator.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.color = ColorPalette.surface,
    this.backgroundColor = Colors.transparent,
    this.size = 18,
    this.strokeWidth = 3,
    this.wavelength = 12,
    this.waveSpeed = 10,
  });

  final Color color;
  final Color backgroundColor;
  final double size;
  final double strokeWidth;
  final double wavelength;
  final double waveSpeed;

  @override
  Widget build(BuildContext context) {
    return M3ECircularWavyProgressIndicator(
      value: null,
      color: color,
      backgroundColor: backgroundColor,
      size: size.r,
      strokeWidth: strokeWidth.w,
      trackStrokeWidth: strokeWidth.w,
      wavelength: wavelength,
      waveSpeed: waveSpeed,
    );
  }
}
