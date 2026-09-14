import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizAutoSaveNotice extends StatelessWidget {
  const QuizAutoSaveNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Icon(
          Icons.shield_outlined,
          size: 16.sp,
          color: ColorPalette.textSecondary,
        ),
        horizontalSpace(6),
        Flexible(
          child: Text(
            'يتم حفظ إجابتك تلقائياً أثناء الاختبار.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
              color: ColorPalette.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
