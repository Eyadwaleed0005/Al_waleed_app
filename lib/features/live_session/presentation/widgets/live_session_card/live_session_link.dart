import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionLink extends StatelessWidget {
  final String sessionLink;

  const LiveSessionLink({super.key, this.sessionLink = 'zoom.us/j/chem-2026'});

  Future<void> _copySessionLink(BuildContext context) async {
    final link = sessionLink.trim();

    if (link.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: link));

    if (!context.mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم نسخ الرابط بنجاح',
      icon: Icons.check_circle_rounded,
    );
  }

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
            child: Text(
              sessionLink,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
                color: ColorPalette.textOceanBlue,
              ),
            ),
          ),
          horizontalSpace(8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _copySessionLink(context),
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy_rounded,
                      size: 20.r,
                      color: ColorPalette.secondary,
                    ),
                    verticalSpace(2),
                    Text(
                      'نسخ',
                      style: AppTextStyle.font12TextPrimaryRegularTajawal(),
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
