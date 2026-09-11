import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText = 'إعادة المحاولة',
  });

  bool get _isNetworkError {
    final normalizedMessage = message.trim().toLowerCase();

    return normalizedMessage.contains('الإنترنت') ||
        normalizedMessage.contains('الانترنت') ||
        normalizedMessage.contains('الشبكة') ||
        normalizedMessage.contains('الاتصال') ||
        normalizedMessage.contains('network') ||
        normalizedMessage.contains('internet') ||
        normalizedMessage.contains('offline') ||
        normalizedMessage.contains('socket');
  }

  @override
  Widget build(BuildContext context) {
    final errorIcon = _isNetworkError
        ? Icons.wifi_off_rounded
        : Icons.error_outline_rounded;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 340.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: ColorPalette.cardBackground.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: ColorPalette.error.withValues(alpha: 0.12),
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 112.r,
                  height: 112.r,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 112.r,
                        height: 112.r,
                        decoration: BoxDecoration(
                          color: ColorPalette.error.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 82.r,
                        height: 82.r,
                        decoration: BoxDecoration(
                          color: ColorPalette.error.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorPalette.error.withValues(alpha: 0.15),
                            width: 1.5.w,
                          ),
                        ),
                        child: Icon(
                          errorIcon,
                          size: 42.sp,
                          color: ColorPalette.error,
                        ),
                      ),
                      Positioned(
                        top: 8.r,
                        right: 10.r,
                        child: Container(
                          width: 18.r,
                          height: 18.r,
                          decoration: BoxDecoration(
                            color: ColorPalette.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorPalette.cardBackground,
                              width: 3.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(22),
                Text(
                  message,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font14TextSecondaryRegularTajawal()
                      .copyWith(height: 1.6),
                ),
                if (onRetry != null) ...[
                  verticalSpace(24),
                  SizedBox(
                    width: 190.w,
                    child: FilledButton.icon(
                      onPressed: onRetry,
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: 20.sp,
                        color: ColorPalette.cardBackground,
                      ),
                      label: Text(
                        retryText,
                        style: AppTextStyle.font14CardBackgroundMediumKufam(),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: ColorPalette.primary,
                        foregroundColor: ColorPalette.cardBackground,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
