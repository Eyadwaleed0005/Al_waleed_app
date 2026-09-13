import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsScreenEmptyView extends StatelessWidget {
  const ExamsScreenEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'لا يوجد امتحان متاح حاليًا',
      subtitle: 'ستظهر امتحاناتك الجديدة هنا عند نشرها.',
      iconWidget: Image.asset(
        AppImage().emptyExam,
        width: 64.w,
        height: 64.h,
        fit: BoxFit.contain,
      ),
      iconBackgroundColor: ColorPalette.softSage,
      iconContainerSize: 144,
      footer: Container(
        width: 280.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: ColorPalette.background,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 7.h),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'كل شيء محدث، ارجع لاحقًا.',
                  style: AppTextStyle.font12TextPrimaryMediumTajawal(),
                ),
              ),
            ),
            horizontalSpace(8),
            Icon(
              Icons.check_circle_outline,
              color: ColorPalette.primary,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
