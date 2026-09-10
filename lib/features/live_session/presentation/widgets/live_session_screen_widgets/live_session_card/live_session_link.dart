import 'package:al_waleed/core/helper/launch_url.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionLink extends StatelessWidget {
  final String sessionLink;
  final bool isLoading;

  const LiveSessionLink({
    super.key,
    required this.sessionLink,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorPalette.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: isLoading
                ? Text(
                    'جاري تحميل الرابط...',
                    style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                  )
                : Text(
                    sessionLink,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.font12TextSecondaryRegularTajawal()
                        .copyWith(color: ColorPalette.textOceanBlue),
                  ),
          ),
          horizontalSpace(8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading
                  ? null
                  : () => UrlLauncherHelper.launchSessionUrl(sessionLink),
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.exit_to_app_rounded,
                      size: 20.r,
                      color: isLoading
                          ? ColorPalette.secondary.withValues(alpha: 0.4)
                          : ColorPalette.secondary,
                    ),
                    verticalSpace(2),
                    Text(
                      'انضم',
                      style: AppTextStyle.font12TextPrimaryRegularTajawal()
                          .copyWith(
                            color: isLoading
                                ? ColorPalette.secondary.withValues(alpha: 0.4)
                                : null,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
