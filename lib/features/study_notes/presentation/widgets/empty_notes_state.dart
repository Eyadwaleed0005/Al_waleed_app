import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyNotesState extends StatelessWidget {
  const EmptyNotesState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAnimations.emptyStateEntrance(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 140.w,
                height: 140.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorPalette.textMuted.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImage().emptyNotesIcon,
                  width: 60.w,
                  height: 60.w,
                ),
              ),
              verticalSpace(20),
              Text(
                'لا توجد مذكرات متاحة حاليًا',
                textAlign: TextAlign.center,
                style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
