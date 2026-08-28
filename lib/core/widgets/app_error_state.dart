import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message = 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
    this.onRetry,
    this.retryText = 'إعادة المحاولة',
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: ColorPalette.error.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 30.sp,
                  color: ColorPalette.error,
                ),
              ),
              verticalSpace(12),
              Text(
                message,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyle.font14TextSecondaryRegularTajawal(),
              ),
              if (onRetry != null) ...[
                verticalSpace(14),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 16.sp,
                    color: ColorPalette.primary,
                  ),
                  label: Text(
                    retryText,
                    style: AppTextStyle.font14TextSecondaryRegularTajawal()
                        .copyWith(color: ColorPalette.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorPalette.primary, width: 1.5.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
