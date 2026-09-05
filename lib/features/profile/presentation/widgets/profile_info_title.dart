import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool showDivider;
  final bool isCopyable;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.showDivider = true,
    this.isCopyable = false,
  });

  Future<void> _copyValue(BuildContext context) async {
    final text = value.trim();

    if (text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) {
      return;
    }

    showAppToast(
      context,
      message: 'تم نسخ البريد الإلكتروني',
      icon: Icons.check_circle_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isCopyable ? () => _copyValue(context) : null,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          if (isCopyable) ...[
                            Icon(
                              Icons.copy_rounded,
                              size: 16.r,
                              color: ColorPalette.textOceanBlue,
                            ),
                            horizontalSpace(6),
                          ],
                          Expanded(
                            child: Text(
                              value,
                              style:
                                  AppTextStyle.font12TextPrimaryBoldTajawal(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              horizontalSpace(12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                  ),
                  horizontalSpace(12),
                  Icon(icon, size: 22.r, color: ColorPalette.textOceanBlue),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: ColorPalette.divider, thickness: 1.h),
      ],
    );
  }
}
