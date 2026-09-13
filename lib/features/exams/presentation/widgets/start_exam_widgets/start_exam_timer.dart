import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartExamTimer extends StatelessWidget {
  const StartExamTimer({super.key, required this.remainingDuration});

  final Duration remainingDuration;

  @override
  Widget build(BuildContext context) {
    final bool isRunningOut = remainingDuration <= const Duration(minutes: 5);

    final Color backgroundColor = isRunningOut
        ? ColorPalette.error.withValues(alpha: 0.12)
        : ColorPalette.deepOlive;

    final Color foregroundColor = isRunningOut
        ? ColorPalette.error
        : ColorPalette.goldHighlight;

    return Container(
      constraints: BoxConstraints(minWidth: 82.w),
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(remainingDuration),
            textDirection: TextDirection.ltr,
            style: AppTextStyle.font13TextHighlightBoldTajawal().copyWith(
              color: foregroundColor,
            ),
          ),
          horizontalSpace(6),
          Icon(Icons.access_time_rounded, size: 16.sp, color: foregroundColor),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final int totalSeconds = duration.isNegative ? 0 : duration.inSeconds;

    final int hours = totalSeconds ~/ Duration.secondsPerHour;

    final int minutes =
        (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;

    final int seconds = totalSeconds % Duration.secondsPerMinute;

    final String formattedMinutes = minutes.toString().padLeft(2, '0');
    final String formattedSeconds = seconds.toString().padLeft(2, '0');

    if (hours == 0) {
      return '$formattedMinutes:$formattedSeconds';
    }

    final String formattedHours = hours.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
}
