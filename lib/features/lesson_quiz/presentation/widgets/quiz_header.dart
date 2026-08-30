import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizHeader extends StatelessWidget implements PreferredSizeWidget {
  const QuizHeader({super.key, required this.title, this.trailingBadge, this.onBack, this.showBackButton = true});

  final String title;
  final Widget? trailingBadge;
  final VoidCallback? onBack;
  final bool showBackButton;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorPalette.surface,
        border: Border(bottom: BorderSide(color: ColorPalette.paleSage, width: 1.0)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 85.w),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.font17TextPrimarySemiBoldKufam().copyWith(
                    color: ColorPalette.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              if (trailingBadge != null) Positioned(right: 14.w, child: trailingBadge!),
              if (showBackButton)
                Positioned(
                  left: 6.w,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: ColorPalette.primary, size: 20.sp),
                    onPressed: onBack ?? () => Navigator.of(context).pop(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizProgressBadge extends StatelessWidget {
  const QuizProgressBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(color: ColorPalette.primary, borderRadius: BorderRadius.circular(20.r)),
      child: Text(
        text,
        style: AppTextStyle.font14TextLightBoldTajawal().copyWith(color: ColorPalette.textLight, fontSize: 13.sp),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
