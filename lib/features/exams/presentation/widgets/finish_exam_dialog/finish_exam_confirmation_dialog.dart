import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinishExamConfirmationDialog extends StatelessWidget {
  const FinishExamConfirmationDialog({
    super.key,
    this.answeredCount = 6,
    this.totalQuestions = 20,
    required this.onConfirmFinish,
    this.onCancel,
  });

  final int answeredCount;
  final int totalQuestions;
  final VoidCallback onConfirmFinish;
  final VoidCallback? onCancel;

  static Future<bool?> show(
    BuildContext context, {
    int answeredCount = 6,
    int totalQuestions = 20,
    required VoidCallback onConfirmFinish,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => FinishExamConfirmationDialog(
        answeredCount: answeredCount,
        totalQuestions: totalQuestions,
        onConfirmFinish: () {
          Navigator.of(context).pop(true);
          onConfirmFinish();
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: const [
            BoxShadow(
              color: ColorPalette.ligthBlackShadow,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: ColorPalette.goldHighlight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  color: ColorPalette.warning,
                  size: 34.sp,
                ),
              ),
            ),
            verticalSpace(18),
            Text(
              'هل أنت متأكد من إنهاء الاختبار؟',
              textAlign: TextAlign.center,
              style: AppTextStyle.font17TextPrimarySemiBoldKufam(),
            ),
            verticalSpace(8),
            Text(
              'لن تتمكن من تعديل إجاباتك بعد تسليم الاختبار.',
              textAlign: TextAlign.center,
              style: AppTextStyle.font14TextSecondaryRegularTajawal(),
            ),
            verticalSpace(16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF2E1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'تمت الإجابة عن ${toArabicNumbers(answeredCount)} من ${toArabicNumbers(totalQuestions)} سؤالاً',
                textAlign: TextAlign.center,
                style: AppTextStyle.font13TextPrimaryMediumTajawal(),
              ),
            ),
            verticalSpace(18),
            CustomButton(
              text: 'إنهاء وتسليم الاختبار',
              onPressed: onConfirmFinish,
              background: ColorPalette.error,
              foreground: ColorPalette.textLight,
              height: 50.h,
            ),
            verticalSpace(10),
            CustomSecondaryButton(
              text: 'العودة للاختبار',
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              backgroundColor: ColorPalette.surface,
              borderColor: const Color(0xFFD6E2DA),
              foregroundColor: ColorPalette.primary,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
