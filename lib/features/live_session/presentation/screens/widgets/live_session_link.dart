import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionLink extends StatelessWidget {
  final String sessionLink;
  const LiveSessionLink({super.key, this.sessionLink = 'zoom.us/j/chem-2026'});
  Future<void> _copyText(BuildContext context) async {
    if (sessionLink.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: sessionLink));

    if (!context.mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم النسخ بنجاح',
      icon: Icons.check_circle_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: ColorPalette.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sessionLink,
            style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
              color: ColorPalette.textOceanBlue,
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: ColorPalette.secondary,
                ),
                onPressed: () => _copyText(context),
              ),

              Text(
                'نسخ',
                style: AppTextStyle.font12TextPrimaryRegularTajawal(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
