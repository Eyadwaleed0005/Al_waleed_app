import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({super.key, required this.questionText, this.imageUrl});

  final String questionText;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [BoxShadow(color: ColorPalette.primary.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            questionText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
          ),
          verticalSpace(16.h),
          if (imageUrl != null) ...[_QuizImage(imageUrl: imageUrl!)],
        ],
      ),
    );
  }
}

class _QuizImage extends StatelessWidget {
  const _QuizImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 180.h),
      decoration: BoxDecoration(
        color: ColorPalette.primarySoftBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
      ),
      padding: EdgeInsets.all(10.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 120.h,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: ColorPalette.primary,
                  strokeWidth: 2.5,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              height: 80.h,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image_outlined, color: ColorPalette.textMuted, size: 32.sp),
                    SizedBox(height: 4.h),
                    Text('تعذّر تحميل الصورة', style: AppTextStyle.font12TextSecondaryRegularTajawal()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
