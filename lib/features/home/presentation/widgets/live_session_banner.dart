import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const LiveSessionBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 350 / 180,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.highlight.withValues(alpha: 0.60),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              Positioned(
                top: 12.h,
                right: 8.w,
                bottom: 12.h,
                child: Image.asset(
                  AppImage().liveSessionBannerIllustration,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 55.h,
                left: 20.w,
                child: Text(
                  'البث المباشر الآن',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font17TextPrimarySemiBoldKufam(),
                ),
              ),
              Positioned(
                bottom: 25.h,
                left: 20.w,
                child: Material(
                  color: ColorPalette.primary,
                  borderRadius: BorderRadius.circular(24.r),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(24.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: TextDirection.rtl,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: ColorPalette.cardBackground,
                            size: 24.r,
                          ),
                          horizontalSpace(4),
                          Text(
                            'انضم للبث',
                            style:
                                AppTextStyle.font14CardBackgroundMediumKufam(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
