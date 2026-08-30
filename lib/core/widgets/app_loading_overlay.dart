import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.isVisible = true,
    required this.child,
  });

  final String? message;
  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVisible)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: ColorPalette.surface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 44.w,
                      height: 44.w,
                      child: const CircularProgressIndicator(
                        color: ColorPalette.primary,
                        strokeWidth: 3,
                      ),
                    ),
                    if (message != null) ...[
                      verticalSpace(16),
                      Text(
                        message!,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
