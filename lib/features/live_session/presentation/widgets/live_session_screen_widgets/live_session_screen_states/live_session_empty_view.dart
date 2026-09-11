import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionEmptyView extends StatelessWidget {
  const LiveSessionEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppEmptyState(
          iconBackgroundColor: ColorPalette.info.withValues(alpha: 0.10),
          iconContainerSize: 140,
          iconSize: 60,
          title: 'لا توجد حصة مباشرة الآن',
          subtitle: 'سيظهر رابط الحصة هنا فور إضافته من المدرس.',
          iconWidget: Icon(
            Icons.videocam_outlined,
            size: 58.r,
            color: ColorPalette.info,
          ),
        ),
        verticalSpace(40),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 22.r,
                color: ColorPalette.info,
              ),
              horizontalSpace(12),
              Expanded(
                child: Text(
                  'ارجع في موعد الحصة المعلن.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font13PrimaryRegularTajawal(),
                ),
              ),
              horizontalSpace(34),
            ],
          ),
        ),
      ],
    );
  }
}
